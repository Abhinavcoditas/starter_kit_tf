module "aws_cognito_user_pool_simple" {
  source  = "lgallard/cognito-user-pool/aws"

  user_pool_name = "${local.environment}-${var.product}-congito-pool"
  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}