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
  default     = "djs-ilb-2019"
}

variable "main_project_authfile" {
  description = "Authentication file for main project (all resources deployed in main.tf)"
  default     = "/Users/dspears/GCP/newkey/djs-ilb-2019-comp.json"
}

#************************************************************************************
# spoke1.tf PROJECT ID & AUTHFILE
#************************************************************************************
variable "spoke1_project" {
  description = "Existing project for spoke1 (can be the same as main project and can be same as main project)."
  default     = "djs-ilb-2019"
}

variable "spoke1_project_authfile" {
  description = "Authentication file for spoke1 project (all resources deployed in spoke1.tf)"
  default     = "/Users/dspears/GCP/newkey/djs-ilb-2019-comp.json"
}

#************************************************************************************
# spoke2.tf PROJECT ID & AUTHFILE
#************************************************************************************
variable "spoke2_project" {
  description = "Existing project for spoke2 (can be the same as main project and can be same as main project)."
  default     = "djs-ilb-2019"
}

variable "spoke2_project_authfile" {
  description = "Authentication file for spoke2 project (all resources deployed in spoke2.tf and can be same as main project)"
  default     = "/Users/dspears/GCP/newkey/djs-ilb-2019-comp.json"
}

#************************************************************************************
# VMSERIES SSH KEY & IMAGE (not required if bootstrapping)
#************************************************************************************
variable "vmseries_ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/2EXlaVYJHG1h0wx5wcerppWhE95ix1IGHt+S7hXSUkD0Vyomd1exHaVO/0u/zj+nqBLK/STVYEGD6wL4zZW7QDEfiisI8m5+H20MW4oWQoh2BKdFRUnQuTg1jvRNI0djLbLNfOlhbwv/J1eSOa+/yRQeoMEvvJT78NPk6QVHb7nqL1kNspM3mnOCfNeBiVGnL3JgApK+d/Z29q2JLnNSiiT8nZggYKi6Iu+HEwXQvc1fqzS0Ls8yYC/R8S4VePvdYXSRhKzwazukFCvz/rWjh4+K7tieQIBoW+YefUvoUnYdxMblUgpD9a8wPOtoEvj+4Y9jB/PSBFZ3nRLtXrbmD0yyDj/XaWrhUfl5AB7fdK3uYg6GI2JI1DNKc4pINNmmKoZ6Nt+nYVxu4hcVv/m91Xnro8SnXs+GPS0pixDWSh0Gi3P/CWnlBJ59iaTZnpmBnGxXgbuXhJaR8PyZ1I2v7SBNuPlW+FzKukoeq0W23fiGKXtcL5sXYJ2GahoqoLh0uXFF7cqXyOviR4ntx9o/2g8l7C+PBsRR9kRzm5ht4GZAnkFyox7JOFWHiqyiOMAo45RsFKCqrMwIMC9+Lc0Gjl9jZXNsI3BRDEpkuZ04ECKS3yHX/oQ8Xri1K2fFfOHsd8HhJABLkPEsF2NC/oLJ5sj/cZDXso+qPy30nllU5w== davejspears@gmail.com"
}

#************************************************************************************
# UBUNTU SSH KEY
#************************************************************************************
variable "ubuntu_ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/2EXlaVYJHG1h0wx5wcerppWhE95ix1IGHt+S7hXSUkD0Vyomd1exHaVO/0u/zj+nqBLK/STVYEGD6wL4zZW7QDEfiisI8m5+H20MW4oWQoh2BKdFRUnQuTg1jvRNI0djLbLNfOlhbwv/J1eSOa+/yRQeoMEvvJT78NPk6QVHb7nqL1kNspM3mnOCfNeBiVGnL3JgApK+d/Z29q2JLnNSiiT8nZggYKi6Iu+HEwXQvc1fqzS0Ls8yYC/R8S4VePvdYXSRhKzwazukFCvz/rWjh4+K7tieQIBoW+YefUvoUnYdxMblUgpD9a8wPOtoEvj+4Y9jB/PSBFZ3nRLtXrbmD0yyDj/XaWrhUfl5AB7fdK3uYg6GI2JI1DNKc4pINNmmKoZ6Nt+nYVxu4hcVv/m91Xnro8SnXs+GPS0pixDWSh0Gi3P/CWnlBJ59iaTZnpmBnGxXgbuXhJaR8PyZ1I2v7SBNuPlW+FzKukoeq0W23fiGKXtcL5sXYJ2GahoqoLh0uXFF7cqXyOviR4ntx9o/2g8l7C+PBsRR9kRzm5ht4GZAnkFyox7JOFWHiqyiOMAo45RsFKCqrMwIMC9+Lc0Gjl9jZXNsI3BRDEpkuZ04ECKS3yHX/oQ8Xri1K2fFfOHsd8HhJABLkPEsF2NC/oLJ5sj/cZDXso+qPy30nllU5w== davejspears@gmail.com"
}

variable "vmseries_image" {
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-byol-814"
  default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle1-814"

  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle2-814"
}
