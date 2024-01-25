resource "aws_api_gateway_rest_api" "this" {
  name               = var.application != null ? "${var.environment}_${var.product}_${var.application}" : "${var.environment}_${var.product}"
  binary_media_types = var.binary_media_types
  api_key_source     = var.api_key_source
  tags = var.application != null ? {
    Environment             = var.environment
    Product                 = var.product
    Application             = var.application
    Can_be_deleted          = true
    Created_using_terraform = true
    } : {
    Environment             = var.environment
    Product                 = var.product
    Can_be_deleted          = true
    Created_using_terraform = true
  }
  endpoint_configuration {
    types = var.endpoint_configuration
  }
}

resource "aws_api_gateway_resource" "this" {
  for_each    = var.api_methods
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = each.value.resource_name
}

resource "aws_api_gateway_method" "this" {
  for_each           = local.root_methods
  rest_api_id        = aws_api_gateway_rest_api.this.id
  resource_id        = each.value.resource_name == "NULL" ? aws_api_gateway_rest_api.this.root_resource_id : aws_api_gateway_resource.this[each.value.resource_name].id
  http_method        = each.value.http_method
  authorization      = each.value.authorization
  authorizer_id      = each.value.authorizer_id
  api_key_required   = each.value.api_key_required
  request_models     = lookup(each.value, "request_model", null) != null ? { "application/json" : aws_api_gateway_model.this[each.value.request_model].name } : {}
  request_parameters = lookup(each.value, "params", null) != null ? { for i in each.value.params : "method.request.querystring.${i}" => false } : null
}

resource "aws_api_gateway_integration" "this" {
  for_each                = local.root_methods
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = each.value.resource_name == "NULL" ? aws_api_gateway_rest_api.this.root_resource_id : aws_api_gateway_resource.this[each.value.resource_name].id
  http_method             = aws_api_gateway_method.this[each.key].http_method
  integration_http_method = "POST"      // Should be POST for AWS Lambda. Refer : https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
  type                    = "AWS_PROXY" // Should be AWS_PROXY for AWS Lambda. Refer : https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
  uri                     = each.value.function_invoke_arn
  cache_key_parameters    = (var.enable_cache_at_resporce == true && lookup(each.value, "params", null) != null) ? [for i in each.value.params : "method.request.querystring.${i}"] : []
}

resource "aws_lambda_permission" "this" {
  for_each      = local.root_methods
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = each.value.resource_name == "NULL" ? "${aws_api_gateway_rest_api.this.execution_arn}/*/*/" : "${aws_api_gateway_rest_api.this.execution_arn}/*/*/${each.value.resource_name}"
}

module "api-gateway-enable-cors" {
  for_each        = local.root_methods
  source          = "squidfunk/api-gateway-enable-cors/aws"
  version         = "0.3.3"
  api_id          = aws_api_gateway_rest_api.this.id
  api_resource_id = aws_api_gateway_resource.this[each.key].id
  allow_origin    = lookup(each.value, "allow_origin", var.allow_origin)
  allow_headers   = lookup(each.value, "allow_headers", var.allow_headers)
  allow_methods   = lookup(each.value, "allow_methods", var.allow_methods)
}

resource "aws_api_gateway_method_response" "this" {
  for_each        = local.root_methods
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = each.value.resource_name == "NULL" ? aws_api_gateway_rest_api.this.root_resource_id : aws_api_gateway_resource.this[each.value.resource_name].id
  http_method     = aws_api_gateway_method.this[each.key].http_method
  response_models = lookup(each.value, "response_model_200", null) != null ? { "application/json" : aws_api_gateway_model.this[each.value.response_model_200].name } : {}
  status_code     = "200"
}

resource "aws_api_gateway_method_response" "this_400" {
  for_each        = local.root_methods
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = each.value.resource_name == "NULL" ? aws_api_gateway_rest_api.this.root_resource_id : aws_api_gateway_resource.this[each.value.resource_name].id
  http_method     = aws_api_gateway_method.this[each.key].http_method
  response_models = lookup(each.value, "response_model_400", null) != null ? { "application/json" : aws_api_gateway_model.this[each.value.response_model_400].name } : {}
  status_code     = "400"
}

resource "aws_api_gateway_method_response" "this_403" {
  for_each        = local.root_methods
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = each.value.resource_name == "NULL" ? aws_api_gateway_rest_api.this.root_resource_id : aws_api_gateway_resource.this[each.value.resource_name].id
  http_method     = aws_api_gateway_method.this[each.key].http_method
  response_models = lookup(each.value, "response_model_403", null) != null ? { "application/json" : aws_api_gateway_model.this[each.value.response_model_403].name } : {}
  status_code     = "403"
}

resource "aws_api_gateway_method_response" "this_404" {
  for_each        = local.root_methods
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = each.value.resource_name == "NULL" ? aws_api_gateway_rest_api.this.root_resource_id : aws_api_gateway_resource.this[each.value.resource_name].id
  http_method     = aws_api_gateway_method.this[each.key].http_method
  response_models = lookup(each.value, "response_model_404", null) != null ? { "application/json" : aws_api_gateway_model.this[each.value.response_model_404].name } : {}
  status_code     = "404"
}

resource "aws_api_gateway_model" "this" {
  for_each     = toset(local.model_file_names)
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = each.key
  content_type = "application/json"
  schema       = file("${path.cwd}/${var.api_models_path}/${each.key}.json")
}























