variable tag {}
variable region {}
variable vpc_id {}
variable vpc_sg_id {}
variable fw_key_name {}
variable fw_vm_type {}
variable fw_sg_source {}
variable fw_min_instances {}
variable fw_max_instances {}
variable fw_scale_threshold_up {}
variable fw_scale_threshold_down {}
variable fw_scale_parameter {}
variable fw_scale_period {}
variable fw_ami {}
variable fw_bucket {}
variable lambda_bucket {}

variable api_key_firewall {}
variable api_key_panorama {}
variable api_key_delicense {}
variable enable_debug {}

variable fw_subnet0_id {
  type = "list"
}

variable fw_subnet1_id {
  type = "list"
}

variable fw_subnet2_id {
  type = "list"
}

variable natgw_subnet_id {
  type = "list"
}

variable lambda_subnet_id {
  type = "list"
}

variable KeyMap {
  default = {
    "Key" = "panw-aws.zip"
  }
}

variable "dependencies" {
  type    = "list"
  default = []
}
