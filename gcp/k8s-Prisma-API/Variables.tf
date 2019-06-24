// PROJECT Variables
variable "container-ver" {
  default = "1.11.8-gke.6"
}

variable "my_gcp_project" {
  default = "djs-gcp-2018"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "credentials_file_path" {
  description = "Path to the JSON file used to describe your account credentials"
  default     = "/Users/dspears/GCP/k8-test/djs-gcp-2018-creds.json"
}

variable "gce_ssh_user" {
  description = " ssh user that is used in the public key"
  default     = "dspears@SJCMAC3024G8WL"
}

variable "gce_ssh_pub_key" {
  description = " ssh key in the format:  ssh-rsa <key> username "
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3bjwWN/LY87FOZH/uuRXS5ku3OXkxsFIvecXMNDoeTNZU5QSM3bAV8t/IU52GsdQO+f2hv9iVulMfYPwxsMcVen32q+t6dcgtChUXPSk+giGqf71iR2xiqGdk6GgC705SUXG/AX1whNI1qT84wP0nOrJaoGo/SZq4Ryel9mptu1Ifj1vMphyw2WOFOMB3IuUYckZHgwbQxZK4iCGJSZmzP+M03oSKZATwvuI1XXUIUVTCcV45NofgCW3Ocfk0UjhK01l1SO3H4+c+v40Zufpqo4vPMOQajTggygpJ7SRCgOYWJxcdx4cr9ASNteii5LQFqAixJD0+0izXfQEUm0/T dspears@SJCMAC3024G8WL"
}

//The rest of the variables do not need to be modified for the K8s Lab
// VM-Series Firewall Variables

variable "firewall_name" {
  default = "firewall"
}

variable "image_fw" {
  default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle1-810"

  //default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-byol-810"
}

variable "machine_type_fw" {
  default = "n1-standard-4"
}

variable "bootstrap_bucket_fw" {
  default = "k8-ew"
}

variable "interface_0_name" {
  default = "management"
}

variable "interface_1_name" {
  default = "untrust"
}

variable "interface_2_name" {
  default = "trust"
}

variable "scopes_fw" {
  default = ["https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}
