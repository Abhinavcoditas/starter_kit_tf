# main.tf

# provider "aws" {
#   region = "us-east-1"  # Change this to your desired AWS region
#   profile = "nikhilesh"
# }

# # Create a Lambda function
# resource "aws_lambda_function" "my_lambda_function" {
#   function_name = "my-lambda-function"
#   runtime       = "nodejs14.x"  # Change the runtime if needed
#   handler       = "index.handler"
#   filename      = "lambda.zip"
#   source_code_hash = filebase64("${path.module}/lambda.zip")

#   role = aws_iam_role.lambda_execution_role.arn

#   # Replace the contents of lambda.zip with your actual Lambda function code
#   # You can package your Lambda function using `zip -r lambda.zip index.js`
# }

# # Create an IAM role for Lambda execution
# resource "aws_iam_role" "lambda_execution_role" {
#   name = "lambda-execution-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       }
#     }
#   ]
# }
# EOF
# }

# # Attach an inline policy to the Lambda execution role
# resource "aws_iam_role_policy_attachment" "lambda_execution_role_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.lambda_execution_role.name
# }

# # Create an API Gateway
# resource "aws_api_gateway_rest_api" "my_api_gateway" {
#   name        = "my-api-gateway"
#   description = "My API Gateway"
# }

# # Create a resource in the API Gateway
# resource "aws_api_gateway_resource" "my_resource" {
#   rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
#   parent_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
#   path_part   = "my-resource"
# }

# # Create a Lambda integration for the resource
# resource "aws_api_gateway_integration" "lambda_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.my_api_gateway.id
#   resource_id             = aws_api_gateway_resource.my_resource.id
#   http_method             = aws_api_gateway_method.lambda_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.my_lambda_function.invoke_arn
# }


# # Create a method for the resource
# resource "aws_api_gateway_method" "lambda_method" {
#   rest_api_id   = aws_api_gateway_rest_api.my_api_gateway.id
#   resource_id   = aws_api_gateway_resource.my_resource.id
#   http_method   = "POST"
#   authorization = "NONE"
# }


# # Deploy the API Gateway
# resource "aws_api_gateway_deployment" "deployment" {
#   depends_on = [aws_api_gateway_integration.lambda_integration]
#   rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
#   stage_name  = "prod"
# }
