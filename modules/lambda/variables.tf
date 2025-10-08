variable "function_name" {
  type = string
}

variable "lambda_role_arn" {
  type = string
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "sns_topic_arn" {
  type = string
}