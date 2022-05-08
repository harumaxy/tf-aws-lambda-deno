provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_iam_role" "lambda_role" {
  name = "Deno_Lambda_Role"
  assume_role_policy = file("./json/lambda_role.json")
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name = "Deno_IAM_Policy_For_Lambda"
  path = "/"
  description = "IAM Policy for Lambda"
  policy = file("./json/iam_policy_for_lambda.json")
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

data "archive_file" "zip_deno_code" {
  type = "zip"
  source_dir = "./src"
  output_path = "./server.zip"

}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename = "deno-lambda-layer.zip" 
  layer_name = "Deno_Lambda_Layer"
  compatible_runtimes = ["provided.al2"]
}

resource "aws_lambda_function" "deno_lambda" {
  filename = "./server.zip"
  function_name = "deno_lambda"
  role = aws_iam_role.lambda_role.arn
  handler = "main.handler"
  runtime = "provided.al2"
  layers = [ aws_lambda_layer_version.lambda_layer.arn ]
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

resource "aws_lambda_function_url" "deno_lambda_url" {
  function_name = aws_lambda_function.deno_lambda.function_name
  authorization_type = "NONE"
}

output "funciton_url" {
  value = aws_lambda_function_url.deno_lambda_url.function_url
}