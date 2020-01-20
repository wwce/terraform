# variable vm_names {
#   type    = list(string)
#   default = ["azure-vm"]
# }
variable vm_count {
}

variable name {

}

variable subnet_id {
}

variable location {
}

variable resource_group_name {
}

variable username {
}

variable password {
}

variable availability_set_id {
  default = ""
}

variable custom_data {
  default = ""
}

variable publisher {
  default = "Canonical"
}

variable offer {
  default = "UbuntuServer"
}

variable sku {
  default = "16.04-LTS"
}

variable backend_pool_ids {
  type = list(string)
  default = null
}

variable tags {
  type = map(string)

  default = {
    tag1 = ""
    tag2 = ""
  }
}

