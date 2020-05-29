#************************************************************************************
# GCP VARIABLES
#************************************************************************************
variable enable_ilbnh {
  default = true
}

variable "region" {
  default = "us-central1"
}

#************************************************************************************
# main.tf PROJECT ID & AUTHFILE
#************************************************************************************
variable "main_project" {
  description = "Existing project ID for main project (all resources deployed in main.tf)"
  default     = "ilb-2019"
}

variable "main_project_authfile" {
  description = "Authentication file for main project (all resources deployed in main.tf)"
  default     = "/Users/dspears/GCP/ilb-2019-key.json"
}

#************************************************************************************
# spoke1.tf PROJECT ID & AUTHFILE
#************************************************************************************
variable "spoke1_project" {
  description = "Existing project for spoke1 (can be the same as main project and can be same as main project)."
  default     = "ilb-2019"
}

variable "spoke1_project_authfile" {
  description = "Authentication file for spoke1 project (all resources deployed in spoke1.tf)"
  default     = "/Users/dspears/GCP/ilb-2019-key.json"
}

#************************************************************************************
# spoke2.tf PROJECT ID & AUTHFILE
#************************************************************************************
variable "spoke2_project" {
  description = "Existing project for spoke2 (can be the same as main project and can be same as main project)."
  default     = "ilb-2019"
}

variable "spoke2_project_authfile" {
  description = "Authentication file for spoke2 project (all resources deployed in spoke2.tf and can be same as main project)"
  default     = "/Users/dspears/GCP/ilb-2019-key.json"
}

#************************************************************************************
# VMSERIES SSH KEY & IMAGE (not required if bootstrapping)
#************************************************************************************
variable "vmseries_ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAXsXFhJABLkPEsF2NC/oLJ5sj/cZDXso+qPy30nllU5w== davespears@gmail.com"
}

#************************************************************************************
# UBUNTU SSH KEY
#************************************************************************************
variable "ubuntu_ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAXsXFhJABLkPEsF2NC/oLJ5sj/cZDXso+qPy30nllU5w== davespears@gmail.com"
 }

variable "vmseries_image" {
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-byol-814"
  default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle1-814"

  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle2-814"
}
