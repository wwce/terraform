/*
*************************************************************************************************************
**                                                                                                         **
**  author:  mmclimans                                                                                     **
**  date:    4/1/19                                                                                        **
**  contact: mmclimans@paloaltonetworks.com                                                                **
**                                                                                                         **  
**                                              SUPPORT POLICY                                             **
**                                                                                                         **
**  This build is released under an as-is, best effort, support policy.                                    **
**  These scripts should be seen as community supported and Palo Alto Networks will contribute our         **
**  expertise as and when possible. We do not provide technical support or help in using or                **
**  troubleshooting the components of the project through our normal support options such as               **
**  Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support    ** 
**  options. The underlying product used (the VM-Series firewall) by the scripts or templates are still    ** 
**  supported, but the support is only for the product functionality and not for help in deploying or      ** 
**  using the template or script itself. Unless explicitly tagged,  all projects or work posted in our     **
**  GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads  **
**  page on https://support.paloaltonetworks.com are provided under the best effort policy.                **
**                                                                                                         **
*************************************************************************************************************
*/

variable "my_gcp_project" {
  description = "Enter the Project ID of an existing GCP project:"
 # default     = "my-gcp-project-0000001"
}
variable "gcp_credentials_file" {
  description = "Enter the JSON GCE API KEY for your environment (the json must exist in the main.tf directory)"
 # default     = "gcp-credentials.json"
} 
variable "bootstrap_bucket" {
  description = "Enter globally unique name for the new bootstrap bucket"
 # default = "vmseries-2tier-75834523984575432"
}
variable "gcp_key_file" {
  description = "Enter your public key (this is only required if you need to access the DB and WEB VMs):"
 # default = "gcloudkey.pub"
}
variable "gcp_ssh_user" {
  description = "Enter the username value associated with the GCP public key:"
  default     = "ubuntu"
}

variable "fw_image" {
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-byol-810"
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle2-810"
  default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle1-814"
}
variable "region" {
  description = "Enter the region to deploy the build:"
  default     = "us-east4"
}
variable "zone" {
  description = "Enter the region's zone:"
  default     = "us-east4-a"
}

/*
*************************************************************************************************************
**                                                                                                         **
**                THE VARIABLES BELOW DO NOT BE CHANGED TO RUN THE TWO-TIER DEMO!!!                        **
**                                                                                                         **
*************************************************************************************************************
*/

#############################################################################################################
# GCP VPC VARIABLES
variable "mgmt_vpc" {
  default = "mgmt-vpc"
}
variable "mgmt_vpc_subnet" {
  default = "mgmt-subnet"
}
variable "mgmt_vpc_subnet_cidr" {
  default = "10.5.0.0/24"
}
variable "untrust_vpc" {
  default = "untrust-vpc"
}
variable "untrust_vpc_subnet" {
  default = "untrust-subnet"
}
variable "untrust_vpc_subnet_cidr" {
  default = "10.5.1.0/24"
}
variable "web_vpc" {
  default = "web-vpc"
}
variable "web_vpc_subnet" {
  default = "web-subnet"
}
variable "web_vpc_subnet_cidr" {
  default = "10.5.2.0/24"
}
variable "db_vpc" {
  default = "db-vpc"
}
variable "db_vpc_subnet" {
  default = "db-subnet"
}
variable "db_vpc_subnet_cidr" {
  default = "10.5.3.0/24"
}
################################################################################################################
################################################################################################################
# VM-SERIES VM VARIABLES
variable "fw_vm_name" {
  default = "vmseries-vm"
}
variable "fw_machine_type" {
  default = "n1-standard-4"
}
variable "fw_machine_cpu" {
  default = "Intel Skylake"
}
variable "fw_nic0_ip" {
  default = "10.5.0.4"
}
variable "fw_nic1_ip" {
  default = "10.5.1.4"
}
variable "fw_nic2_ip" {
  default = "10.5.2.4"
}
variable "fw_nic3_ip" {
  default = "10.5.3.4"
}
################################################################################################################
################################################################################################################
# WEB-VM VARIABLES
variable "web_vm_name" {
  default = "web-vm"
}
variable "web_machine_type" {
  default = "f1-micro"
}
variable "web_nic0_ip" {
  default = "10.5.2.5"
}
################################################################################################################
################################################################################################################
# DB-VM VARIABLES
variable "db_vm_name" {
  default = "db-vm"
}
variable "db_machine_type" {
  default = "f1-micro"
}
variable "db_nic0_ip" {
  default = "10.5.3.5"
}   
variable "vm_image" {
   default = "ubuntu-os-cloud/ubuntu-1804-lts"
}
################################################################################################################
################################################################################################################
variable "fw_scopes" {
  default = [
    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}

variable "vm_scopes" {
  default = ["https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/compute.readonly",
  ]
}


