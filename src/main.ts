import {
  APIGatewayProxyEventV2,
  APIGatewayProxyResultV2,
  Context,
} from "https://deno.land/x/lambda/mod.ts";

export async function handler(
  event: APIGatewayProxyEventV2,
  context: Context,
): Promise<APIGatewayProxyResultV2> {
  return await {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello World",
      input: event,
    }),
  };
}
