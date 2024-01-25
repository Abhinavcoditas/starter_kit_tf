#####condition if child_name is not null then call this resource  
resource "aws_api_gateway_resource" "child" {
  for_each    = local.child_methods
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.this[each.value.resource_name].id
  path_part   = each.value.child_name
}

resource "aws_api_gateway_method" "child" {
  for_each         = local.child_methods
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = aws_api_gateway_resource.child[each.value.resource_name].id
  http_method      = each.value.http_method
  authorization    = each.value.authorization
  authorizer_id    = each.value.authorizer_id
  api_key_required = each.value.api_key_required
  request_models   = lookup(each.value, "request_model", null) != null ? { "application/json" : aws_api_gateway_model.this[each.value.request_model].name } : {}
}

resource "aws_api_gateway_integration" "child" {
  for_each                = local.child_methods
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.child[each.value.resource_name].id
  http_method             = aws_api_gateway_method.child[each.key].http_method
  integration_http_method = "POST"      // Should be POST for AWS Lambda. Refer : https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
  type                    = "AWS_PROXY" // Should be AWS_PROXY for AWS Lambda. Refer : https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
  uri                     = each.value.function_invoke_arn
}

resource "aws_lambda_permission" "child" {
  for_each      = local.child_methods
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = each.value.resource_name == "NULL" ? "${aws_api_gateway_rest_api.this.execution_arn}/*/*/" : "${aws_api_gateway_rest_api.this.execution_arn}/*/*/${each.value.resource_name}/${each.value.child_name}"
}

module "api-gateway-enable-cors-child" {
  for_each        = local.child_methods
  source          = "squidfunk/api-gateway-enable-cors/aws"
  version         = "0.3.3"
  api_id          = aws_api_gateway_rest_api.this.id
  api_resource_id = aws_api_gateway_resource.child[each.key].id
  allow_origin    = lookup(each.value, "allow_origin", var.allow_origin)
  allow_headers   = lookup(each.value, "allow_headers", var.allow_headers)
  allow_methods   = lookup(each.value, "allow_methods", var.allow_methods)
}

resource "aws_api_gateway_method_response" "child" {
  for_each        = local.child_methods
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.child[each.value.resource_name].id
  http_method     = aws_api_gateway_method.child[each.key].http_method
  response_models = lookup(each.value, "response_model_200", null) != null ? { "application/json" : aws_api_gateway_model.this[each.value.response_model_200].name } : {}
  status_code     = "200"
}

resource "aws_api_gateway_method_response" "child_400" {
  for_each        = local.child_methods
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.child[each.value.resource_name].id
  http_method     = aws_api_gateway_method.child[each.key].http_method
  response_models = lookup(each.value, "response_model_400", null) != null ? { "application/json" : aws_api_gateway_model.this[each.value.response_model_400].name } : {}
  status_code     = "400"
}

resource "aws_api_gateway_method_response" "child_403" {
  for_each        = local.child_methods
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.child[each.value.resource_name].id
  http_method     = aws_api_gateway_method.child[each.key].http_method
  response_models = lookup(each.value, "response_model_403", null) != null ? { "application/json" : aws_api_gateway_model.this[each.value.response_model_403].name } : {}
  status_code     = "403"
}

resource "aws_api_gateway_method_response" "child_404" {
  for_each        = local.child_methods
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.child[each.value.resource_name].id
  http_method     = aws_api_gateway_method.child[each.key].http_method
  response_models = lookup(each.value, "response_model_404", null) != null ? { "application/json" : aws_api_gateway_model.this[each.value.response_model_404].name } : {}
  status_code     = "404"
}
























