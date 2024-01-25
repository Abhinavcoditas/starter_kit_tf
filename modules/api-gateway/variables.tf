variable "application" {
  type    = string
  default = null
}
variable "environment" {
  type = string
}
variable "product" {
  type = string
}
variable "binary_media_types" {
  type    = list(any)
  default = []
}
variable "endpoint_configuration" {
  type    = list(any)
  default = ["REGIONAL"]
}
variable "api_key_source" {
  type    = string
  default = "HEADER"
}

variable "api_methods" {
  type = any
}

variable "allow_origin" {
  type    = string
  default = "*"
}
variable "allow_headers" {
  type = list(string)
  default = [
    "Authorization",
    "Content-Type",
    "X-Amz-Date",
    "X-Amz-Security-Token",
    "X-Api-Key"
  ]
}
variable "allow_methods" {
  type = list(string)
  default = [
    "OPTIONS",
    "HEAD",
    "GET",
    "POST",
    "PUT",
    "PATCH",
    "DELETE",
  ]
}

variable "api_models_path" {
  type    = string
  default = "api_models"
}

variable "stage_name" {
  type    = string
  default = "api"
}

variable "enable_cache_at_stage" {
  type = bool
}

variable "enable_cache_at_resporce" {
  type = bool
}

variable "xray_tracing_enabled" {
  type    = bool
  default = true
}

variable "cache_ttl_in_seconds" {
  type    = number
  default = 300
}

variable "cache_cluster_size" {
  type    = number
  default = 1.6
}

variable "require_authorization_for_cache_control" {
  type    = bool
  default = false
}