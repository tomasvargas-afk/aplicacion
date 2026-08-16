// Supabase Edge Function: analyzes a food photo with Claude's vision and
// returns an estimated name + calories/macros. Keeps the Anthropic API key
// server-side — the Flutter client never sees it.
//
// Deploy: supabase functions deploy analyze-food
// Configure once: supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
import Anthropic from "npm:@anthropic-ai/sdk@0.32.1";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Per-user cap so a single (possibly compromised or abusive) account can't
// run up the Anthropic bill by hammering this endpoint.
const RATE_LIMIT_PER_HOUR = 20;

const ALLOWED_MEDIA_TYPES = new Set([
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/gif",
]);

// ~5MB of decoded image data (base64 is ~4/3 the size of the raw bytes).
const MAX_BASE64_LENGTH = 7_000_000;

const RESULT_SCHEMA = {
  type: "object",
  properties: {
    food_name: { type: "string", description: "Nombre corto del plato o alimento, en español" },
    calories: { type: "number" },
    protein_g: { type: "number" },
    carbs_g: { type: "number" },
    fat_g: { type: "number" },
  },
  required: ["food_name", "calories", "protein_g", "carbs_g", "fat_g"],
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
        { error: "Alcanzaste el límite de análisis por hora. Intenta de nuevo más tarde." },
        429,
      );
    }

    const { image_base64, media_type } = await req.json();
    if (!image_base64 || !media_type) {
      return jsonResponse({ error: "Falta la imagen (image_base64/media_type)" }, 400);
    }
    if (typeof image_base64 !== "string" || typeof media_type !== "string") {
      return jsonResponse({ error: "Formato de imagen inválido" }, 400);
    }
    if (!ALLOWED_MEDIA_TYPES.has(media_type)) {
      return jsonResponse({ error: "Tipo de imagen no soportado" }, 400);
    }
    if (image_base64.length > MAX_BASE64_LENGTH) {
      return jsonResponse({ error: "La imagen es demasiado grande" }, 413);
    }

    const apiKey = Deno.env.get("ANTHROPIC_API_KEY");
    if (!apiKey) {
      return jsonResponse({ error: "El servicio de análisis no está configurado" }, 500);
    }

    await adminClient.from("ai_usage_log").insert({ user_id: userId });

    const client = new Anthropic({ apiKey });

    const message = await client.messages.create({
      model: "claude-sonnet-5",
      max_tokens: 1024,
      messages: [
        {
          role: "user",
          content: [
            { type: "image", source: { type: "base64", media_type, data: image_base64 } },
            {
              type: "text",
              text:
                "Identifica el plato o alimento principal de esta foto y estima sus calorías y " +
                "macronutrientes totales para la porción visible. Antes de estimar, fíjate en " +
                "pistas de tamaño en la imagen (tamaño del plato/envase, cubiertos, comparación " +
                "con la mano u otros objetos de referencia) para calcular la porción con la mayor " +
                "precisión posible. Si hay varios componentes distintos en el plato (por ejemplo " +
                "proteína, carbohidrato, vegetales, salsas), considera cada uno por separado antes " +
                "de sumar el total. Da tu mejor estimación aunque no sea exacta.",
            },
          ],
        },
      ],
      output_config: { format: { type: "json_schema", schema: RESULT_SCHEMA } },
    });

    if (message.stop_reason === "refusal") {
      return jsonResponse({ error: "No se pudo analizar esta imagen" }, 422);
    }

    const textBlock = message.content.find((block) => block.type === "text");
    if (!textBlock || textBlock.type !== "text") {
      return jsonResponse({ error: "El modelo no devolvió una respuesta de texto" }, 502);
    }

    const parsed = JSON.parse(textBlock.text);
    return jsonResponse(parsed);
  } catch (error) {
    console.error(error);
    return jsonResponse({ error: "No se pudo analizar la foto" }, 500);
  }
});
