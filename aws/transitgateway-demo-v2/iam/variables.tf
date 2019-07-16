variable "name" {
  description = "The name of the policy"
  default     = ""
}

variable "path" {
  description = "The path of the policy in IAM"

  default     = "/"
}

variable "description" {
  description = "The description of the policy"

  default     = "IAM Policy"
}

variable "policy" {
  description = "The path of the policy in IAM (tpl file)"
  default     = ""
}
