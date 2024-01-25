locals {
  
  lambdas = {
    for i in local.lambdas_list :
    "${local.environment}-${var.product}-${i.function_name}" => i
  }

  lambdas_list = [
    {
      attach_extra_policy = true
      source_code_dir     = "lambda.zip"
      function_name       = "login"
      runtime             = "${var.runtime}"
      timeout             = 900
      handler             = "login.lambda_handler"
      layers              = []
      memory_size         = 257

      environment_variables = {
        //table_name                 = local.iam_permissions_table.table.name
        //api_keys_table_name        = local.api_keys_table.table.name
        //log_group_name             = aws_cloudwatch_log_group.sync_call_errors.name
        # put_log_function_name      = "arn:aws:lambda:${local.region}:${var.account_id}:function:${var.environment}_${var.product}_put_log"
        # update_quota_function_name = "arn:aws:lambda:${local.region}:${var.account_id}:function:${var.environment}_${var.product}_update_quota"
        # PYTHONHASHSEED             = 0
      }
    }
    # {
    #   attach_extra_policy = true
    #   source_code_dir     = "lambda.zip"
    #   function_name       = "lambda1"
    #   runtime             = "${var.runtime}"
    #   timeout             = 900
    #   handler             = "lambda.lambda_handler"
    #   layers              = []
    #   memory_size         = 257

    #   environment_variables = {
    #     //table_name                 = local.iam_permissions_table.table.name
    #     //api_keys_table_name        = local.api_keys_table.table.name
    #     //log_group_name             = aws_cloudwatch_log_group.sync_call_errors.name
    #     # put_log_function_name      = "arn:aws:lambda:${local.region}:${var.account_id}:function:${var.environment}_${var.product}_put_log"
    #     # update_quota_function_name = "arn:aws:lambda:${local.region}:${var.account_id}:function:${var.environment}_${var.product}_update_quota"
    #     # PYTHONHASHSEED             = 0
    #   }
    # },
    # {
    #   attach_extra_policy = true
    #   source_code_dir     = "lambda.zip"
    #   function_name       = "lambda2"
    #   runtime             = "${var.runtime}"
    #   timeout             = 900
    #   handler             = "lambda.lambda_handler"
    #   layers              = []
    #   memory_size         = 257

    #   environment_variables = {
    #     //table_name                 = local.iam_permissions_table.table.name
    #     //api_keys_table_name        = local.api_keys_table.table.name
    #     //log_group_name             = aws_cloudwatch_log_group.sync_call_errors.name
    #     # put_log_function_name      = "arn:aws:lambda:${local.region}:${var.account_id}:function:${var.environment}_${var.product}_put_log"
    #     # update_quota_function_name = "arn:aws:lambda:${local.region}:${var.account_id}:function:${var.environment}_${var.product}_update_quota"
    #     # PYTHONHASHSEED             = 0
    #   }
    # }
  ]
}