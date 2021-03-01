variable "Billing_Account" {
}

variable "Blue_Team_Name" {
}

variable "Red_Team_Name" {
}

variable "GCP_Region" {
}

variable "GCP_Zone" {
}

variable "Management_Subnet_CIDR" {
}

variable "Untrust_Subnet_CIDR" {
}

variable "Trust_Subnet_CIDR" {
}

variable "Attacker_Subnet_CIDR" {
}

variable "FW_Mgmt_IP" {
}

variable "FW_Untrust_IP" {
}

variable "FW_Trust_IP" {
}

variable "WebLB_IP" {
}

variable "Webserver_IP1" {
}

variable "Webserver_IP2" {
}

variable "Attacker_IP" {
}

variable "Server_Initscript_Path" {
}

variable "Attacker_Initscript_Path" {
}

variable "HC_Request_Path" {
}

variable "Content_Bucket" {
}

variable "Public_Key_File" {
  description = "Entire path to public SSH key file.  If you do not have a public key, run >> ssh-keygen -f ~/.ssh/demo-key -t rsa -C admin"
}