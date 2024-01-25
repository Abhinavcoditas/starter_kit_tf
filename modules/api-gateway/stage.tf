resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_rest_api.this]
}

resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch_role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"]
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "apigateway.amazonaws.com"
                ]
            },
            "Action": [
                "sts:AssumeRole"
            ]
        }
    ]
})
  tags = {
    createdBy = "terraform"
  }
}
resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch_role.arn
  depends_on = [ aws_iam_role.cloudwatch_role ]
}

resource "aws_api_gateway_stage" "this" {
  deployment_id         = aws_api_gateway_deployment.this.id
  rest_api_id           = aws_api_gateway_rest_api.this.id
  stage_name            = var.stage_name
  cache_cluster_enabled = var.enable_cache_at_stage
  cache_cluster_size    = var.enable_cache_at_stage == true ? var.cache_cluster_size : 0.5
  xray_tracing_enabled  = var.xray_tracing_enabled
  depends_on            = [aws_cloudwatch_log_group.this]
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.this.id}/${var.stage_name}"
  retention_in_days = 7
  tags = {
    "ExportToS3" = "true"
  }
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    cache_ttl_in_seconds                    = var.enable_cache_at_stage == true ? var.cache_ttl_in_seconds : 0
    logging_level                           = "INFO"
    require_authorization_for_cache_control = var.require_authorization_for_cache_control
  }
  depends_on            = [aws_api_gateway_account.this]
}