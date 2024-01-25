# output "auth" {
#   value = aws_api_gateway_authorizer.this
# }
# output "api-gateway" {
#   value = module.api-gateway
# }
output "lambda" {
  value = module.lambdas
}