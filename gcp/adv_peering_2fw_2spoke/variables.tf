#************************************************************************************
# GCP VARIABLES
#************************************************************************************
variable "region" {
  default = "us-east4"
}

#************************************************************************************
# main.tf PROJECT ID & AUTHFILE
#************************************************************************************
variable "main_project" {
  description = "Existing project ID for main project (all resources deployed in main.tf)"
  default     = "host-project-242119"
}

variable "main_project_authfile" {
  description = "Authentication file for main project (all resources deployed in main.tf)"
  default     = "host-project-b533f464016c.json"
}

#************************************************************************************
# spoke1.tf PROJECT ID & AUTHFILE
#************************************************************************************
variable "spoke1_project" {
  description = "Existing project for spoke1 (can be the same as main project and can be same as main project)."
  default     = "host-project-242119"
}

variable "spoke1_project_authfile" {
  description = "Authentication file for spoke1 project (all resources deployed in spoke1.tf)"
  default     = "host-project-b533f464016c.json"
}

#************************************************************************************
# spoke2.tf PROJECT ID & AUTHFILE
#************************************************************************************
variable "spoke2_project" {
  description = "Existing project for spoke2 (can be the same as main project and can be same as main project)."
  default     = "host-project-242119"
}

variable "spoke2_project_authfile" {
  description = "Authentication file for spoke2 project (all resources deployed in spoke2.tf and can be same as main project)"
  default     = "host-project-b533f464016c.json"
}

#************************************************************************************
# VMSERIES SSH KEY & IMAGE (not required if bootstrapping)
#************************************************************************************
variable "vmseries_ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDa7UUo1v42jebXVHlBof9E9GAFfalTndZQmvlmFu9e88euqrLI4xEZwg9ihwPFVTXOmrAogye6ojv5rbf3f13ZFYB+USjcR/9RFX+DKkPmXluC5Xq3z0ZlxY3QETHSlr6G8pfEqNwFebYJmKZ1MVNUztmb1DTIhjbFN4IAK/8NzQTbOYnEbXV4BB9E9Xe7dtuDuQrgaoII7KITnYdY4tjI10/K01Ay52PC7eISvZBRZntto2Mg1WjWQAwyIJHFC8nXoE04Wbzv91ohLfs/Og/dSOhdFymX1KVx5XSZWZ0POEOFY3rsDHFDrMiZIxipfuvBtEsznExp7ybkIDtWOxNX admin"
}

#************************************************************************************
# UBUNTU SSH KEY
#************************************************************************************
variable "ubuntu_ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDk7y0D0Rz4F5J9Lu7gtTRTaEkJdWNLpmnDXcvHvaNC3euQ0KITIU6XaPHlXiB1M8pCrmBw3CFkFLxnPoGHrcN39wi2BR9d6Y1piz1v0gJqbggdMloSnrz51OVPqqC5BjtN/lB9hTcyNrh4MDfv37sRChHJb31s934vbj+qeiR16ZeLHH5moRXnyuzIvVUePnXHZvYz0M+YxJtvf806cz+Dvio72Y5g69/DUWReTNZ3h51MKseYMJT0Uu7mPJUZlH+xURc8zzzFazTE1jD7qL2z497si7oVHzmHm5nCECNayore3jzp5YYQkzEfe2fujxeM4UGlEBYuMkUxlH8QV5qN ubuntu"
}

variable "vmseries_image" {
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-byol-814"
   default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle1-814"
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle2-814"
}
