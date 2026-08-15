// Supabase Edge Function: analyzes a food photo with Claude's vision and
// returns an estimated name + calories/macros. Keeps the Anthropic API key
// server-side — the Flutter client never sees it.
//
// Deploy: supabase functions deploy analyze-food
// Configure once: supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
import Anthropic from "npm:@anthropic-ai/sdk@0.32.1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

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
    const { image_base64, media_type } = await req.json();
    if (!image_base64 || !media_type) {
      return jsonResponse({ error: "Falta la imagen (image_base64/media_type)" }, 400);
    }

    const apiKey = Deno.env.get("ANTHROPIC_API_KEY");
    if (!apiKey) {
      return jsonResponse({ error: "El servicio de análisis no está configurado" }, 500);
    }

    const client = new Anthropic({ apiKey });

    const message = await client.messages.create({
      model: "claude-haiku-4-5",
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
                "macronutrientes totales para la porción que se ve en la imagen. Da tu mejor " +
                "estimación aunque no sea exacta.",
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
