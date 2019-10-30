variable vm_names {
  type    = list(string)
  default = ["azure-vm"]
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

variable tags {
  type = map(string)

  default = {
    tag1 = ""
    tag2 = ""
  }
}

