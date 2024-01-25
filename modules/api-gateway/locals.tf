locals {
  model_files = toset(fileset("${path.cwd}/${var.api_models_path}", "*"))
  model_file_names = [
    for file in local.model_files :
    trimsuffix(file, ".json")
  ]

  root_methods = {
    for k, v in var.api_methods :
    k => v
    if v.child_name == null
  }

  child_methods = {
    for k, v in var.api_methods :
    k => v
    if v.child_name != null
  }
}