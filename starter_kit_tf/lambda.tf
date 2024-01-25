module "lambdas" {
  source                = "terraform-aws-modules/lambda/aws"
  for_each              = local.lambdas
  function_name         = each.key
  handler               = each.value.handler
  memory_size           = each.value.memory_size
  runtime               = each.value.runtime
  timeout               = each.value.timeout
  environment_variables = each.value.environment_variables
  layers                = each.value.layers
  source_path           = "./lambda.py"
  architectures = try(each.value.architectures, [
    "x86_64"
  ])
}