module "api-gateway" {
  source                   = "../modules/api-gateway"
  environment              = local.environment
  product                  = var.product
  api_methods              = local.api_methods
  enable_cache_at_resporce = false
  enable_cache_at_stage    = false
  xray_tracing_enabled     = false
  depends_on               = [ module.lambdas ]
}
resource "aws_api_gateway_authorizer" "this" {
  name                             = "authorizer"
  rest_api_id                      = module.api-gateway.api_gateway.id
  //authorizer_uri                   = "module.lambdas.lambda.${local.environment}_${var.product}_lambda.lambda_function_invoke_arn"
  authorizer_uri                   = module.lambdas["${local.environment}-${var.product}-login"].lambda_function_invoke_arn
  type                             = "REQUEST"
  authorizer_result_ttl_in_seconds = 900
  depends_on                       = [ module.lambdas ]
}

