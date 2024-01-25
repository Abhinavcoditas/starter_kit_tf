# locals {
#   environment              = "dev"
# }

locals {
  environment = terraform.workspace
  api_details = lookup(var.environment, local.environment)
  tags = {
    Terraform   = "true"
    environment = local.environment
  }
}  