locals {
  api_methods = {
    for k, v in local.api_methods_list :
    k => merge(v,
      {
        authorizer_id       = aws_api_gateway_authorizer.this.id
        function_name       = module.lambdas["${local.environment}-${var.product}-${v.resource_name}"].lambda_function_name
        function_invoke_arn = module.lambdas["${local.environment}-${var.product}-${v.resource_name}"].lambda_function_invoke_arn
    })
  }
  api_methods_list = {
    login = {
      parent_resource_id = "root"
      resource_name      = "login"
      http_method        = "POST"
      authorization      = "CUSTOM"
      child_name         = null
      api_key_required   = false
    }
  }
}