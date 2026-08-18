// Supabase Edge Function: given an exercise name and its recent set
// history (reps/weight, most recent first), asks Claude for a short
// coaching suggestion + a concrete next-session target. This is
// deliberately AI (not a fixed formula) because the value here is
// reading the trend across sessions -- plateaus, consistent overreach,
// missed reps -- not just applying a fixed percentage bump.
import Anthropic from "npm:@anthropic-ai/sdk@0.32.1";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Shares the same per-user hourly budget as the other AI functions (see
// analyze-food's ai_usage_log table) since all three call the same key.
const RATE_LIMIT_PER_HOUR = 20;
const MAX_SETS = 30;

const RESULT_SCHEMA = {
  type: "object",
  properties: {
    suggestion_text: {
      type: "string",
      description: "Sugerencia breve y motivadora en español, 1-2 frases",
    },
    suggested_weight_kg: { type: "number" },
    suggested_reps: { type: "integer" },
  },
  required: ["suggestion_text", "suggested_weight_kg", "suggested_reps"],
  additionalProperties: false,
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const jsonResponse = (body: unknown, status = 200) =>
    new Response(JSON.stringify(body), {
      status,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return jsonResponse({ error: "No autorizado" }, 401);
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    const userClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const { data: userData, error: userError } = await userClient.auth.getUser();
    if (userError || !userData.user) {
      return jsonResponse({ error: "No autorizado" }, 401);
    }
    const userId = userData.user.id;

    const adminClient = createClient(supabaseUrl, serviceRoleKey);
    const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000).toISOString();
    const { count } = await adminClient
      .from("ai_usage_log")
      .select("*", { count: "exact", head: true })
      .eq("user_id", userId)
      .gte("created_at", oneHourAgo);

    if ((count ?? 0) >= RATE_LIMIT_PER_HOUR) {
      return jsonResponse(
        { error: "Alcanzaste el límite de sugerencias por hora. Intenta de nuevo más tarde." },
        429,
      );
    }

    const { exercise_name, recent_sets } = await req.json();
    if (typeof exercise_name !== "string" || !exercise_name.trim()) {
      return jsonResponse({ error: "Falta el nombre del ejercicio" }, 400);
    }
    if (!Array.isArray(recent_sets) || recent_sets.length === 0) {
      return jsonResponse({ error: "No hay historial suficiente para este ejercicio" }, 400);
    }
    const sets = recent_sets.slice(0, MAX_SETS);
    const validSets = sets.every((s) =>
      s && typeof s === "object" &&
      (s.reps_done === null || typeof s.reps_done === "number") &&
      (s.weight_kg === null || typeof s.weight_kg === "number")
    );
    if (!validSets) {
      return jsonResponse({ error: "Historial de series inválido" }, 400);
    }

    const apiKey = Deno.env.get("ANTHROPIC_API_KEY");
    if (!apiKey) {
      return jsonResponse({ error: "El servicio de sugerencias no está configurado" }, 500);
    }

    await adminClient.from("ai_usage_log").insert({ user_id: userId });

    const client = new Anthropic({ apiKey });

    const historyText = sets
      .map((s, i) => `${i + 1}. ${s.reps_done ?? "?"} reps x ${s.weight_kg ?? "?"}kg`)
      .join("\n");

    const message = await client.messages.create({
      model: "claude-sonnet-5",
      max_tokens: 512,
      messages: [
        {
          role: "user",
          content: [
            {
              type: "text",
              text:
                `Eres un entrenador personal. Este es el historial reciente de series de la ` +
                `persona en "${exercise_name}" (la primera línea es la más reciente):\n\n` +
                `${historyText}\n\n` +
                `Basándote en la tendencia (progreso, estancamiento, o series incompletas), da ` +
                `una sugerencia breve y concreta para la próxima sesión: si debería subir peso, ` +
                `mantenerlo y enfocarse en técnica/reps, o bajar la carga. Sé específico con el ` +
                `peso y las repeticiones sugeridas, usando principios de sobrecarga progresiva ` +
                `(incrementos pequeños y razonables, no saltos grandes).`,
            },
          ],
        },
      ],
      output_config: { format: { type: "json_schema", schema: RESULT_SCHEMA } },
    });

    if (message.stop_reason === "refusal") {
      return jsonResponse({ error: "No se pudo generar la sugerencia" }, 422);
    }

    const textBlock = message.content.find((block) => block.type === "text");
    if (!textBlock || textBlock.type !== "text") {
      return jsonResponse({ error: "El modelo no devolvió una respuesta de texto" }, 502);
    }

    const parsed = JSON.parse(textBlock.text);
    return jsonResponse(parsed);
  } catch (error) {
    console.error(error);
    return jsonResponse({ error: "No se pudo generar la sugerencia" }, 500);
  }
});
