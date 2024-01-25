variable "runtime" {
  type = string
  default = "python3.9"
  description = "lambda runtime value"
}

variable "aws-region" {
  type = string
  default = "us-east-1"
}

variable "product" {
  type = string
  default = "test"
}

variable "environment" {
  type = map(any)
}

variable "profile" {
  type = string
  default = "nikhilesh"
}