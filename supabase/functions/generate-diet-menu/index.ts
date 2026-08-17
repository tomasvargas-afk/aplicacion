// Supabase Edge Function: given daily calorie/macro targets (already
// computed client-side with the Mifflin-St Jeor formula — this function
// does NOT touch that math), asks Claude to design a realistic 4-meal menu
// with specific foods and gram quantities that add up close to the
// targets. Replaces the old static per-goal dish lookup table.
import Anthropic from "npm:@anthropic-ai/sdk@0.32.1";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Shares the same per-user hourly budget as analyze-food (see that
// function's ai_usage_log table) since both call the same Anthropic key.
const RATE_LIMIT_PER_HOUR = 20;

const GOAL_LABELS: Record<string, string> = {
  lose_fat: "bajar grasa",
  maintain: "mantener peso",
  gain_muscle: "ganar músculo",
  recomposition: "recomposición corporal",
};

const RESULT_SCHEMA = {
  type: "object",
  properties: {
    meals: {
      type: "array",
      minItems: 4,
      maxItems: 4,
      items: {
        type: "object",
        properties: {
          meal_type: { type: "string", enum: ["breakfast", "lunch", "dinner", "snack"] },
          suggested_food: {
            type: "string",
            description: "Plato real con cantidades en gramos, en español, ej: '150g pechuga de pollo a la plancha, 120g arroz integral, ensalada con 1 cdta aceite de oliva'",
          },
          calories: { type: "number" },
          protein_g: { type: "number" },
          carbs_g: { type: "number" },
          fat_g: { type: "number" },
        },
        required: ["meal_type", "suggested_food", "calories", "protein_g", "carbs_g", "fat_g"],
        additionalProperties: false,
      },
    },
  },
  required: ["meals"],
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
        { error: "Alcanzaste el límite de generaciones por hora. Intenta de nuevo más tarde." },
        429,
      );
    }

    const { daily_calories, protein_g, carbs_g, fat_g, goal } = await req.json();
    const numbers = [daily_calories, protein_g, carbs_g, fat_g];
    if (numbers.some((n) => typeof n !== "number" || !Number.isFinite(n) || n < 0)) {
      return jsonResponse({ error: "Datos de macros inválidos" }, 400);
    }
    if (typeof goal !== "string" || !(goal in GOAL_LABELS)) {
      return jsonResponse({ error: "Objetivo inválido" }, 400);
    }

    const apiKey = Deno.env.get("ANTHROPIC_API_KEY");
    if (!apiKey) {
      return jsonResponse({ error: "El servicio de generación no está configurado" }, 500);
    }

    await adminClient.from("ai_usage_log").insert({ user_id: userId });

    const client = new Anthropic({ apiKey });

    const message = await client.messages.create({
      model: "claude-sonnet-5",
      max_tokens: 1536,
      messages: [
        {
          role: "user",
          content: [
            {
              type: "text",
              text:
                `Diseña un menú diario de 4 comidas (desayuno, almuerzo, cena, snack) para una ` +
                `persona con objetivo de ${GOAL_LABELS[goal]}. Los totales del día deben sumar ` +
                `aproximadamente: ${Math.round(daily_calories)} kcal, ${Math.round(protein_g)}g ` +
                `proteína, ${Math.round(carbs_g)}g carbohidratos, ${Math.round(fat_g)}g grasa. ` +
                `Usa platos reales y comunes en Latinoamérica, con cantidades en gramos concretas ` +
                `y realistas (no inventes cantidades que no correspondan a los macros de cada ` +
                `alimento). Reparte las calorías de forma razonable entre las 4 comidas ` +
                `(desayuno y snack más livianos que almuerzo y cena). Varía los alimentos, evita ` +
                `repetir la misma proteína en todas las comidas si es posible.`,
            },
          ],
        },
      ],
      output_config: { format: { type: "json_schema", schema: RESULT_SCHEMA } },
    });

    if (message.stop_reason === "refusal") {
      return jsonResponse({ error: "No se pudo generar el menú" }, 422);
    }

    const textBlock = message.content.find((block) => block.type === "text");
    if (!textBlock || textBlock.type !== "text") {
      return jsonResponse({ error: "El modelo no devolvió una respuesta de texto" }, 502);
    }

    const parsed = JSON.parse(textBlock.text);
    return jsonResponse(parsed);
  } catch (error) {
    console.error(error);
    return jsonResponse({ error: "No se pudo generar el menú" }, 500);
  }
});
