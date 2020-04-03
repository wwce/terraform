Billing_Account = "<Billing ID>"

Base_Project_Name = "<Base Project Name>"

Public_Key_Path = "~/.ssh/id_rsa.pub"

GCP_Region = "<Region>"

#FW_PanOS = "byol-904"              # Uncomment for PAN-OS 9.0.4 - BYOL
FW_PanOS  = "bundle1-904"           # Uncomment for PAN-OS 9.0.4 - PAYG Bundle 1
#FW_PanOS = "bundle2-904"           # Uncomment for PAN-OS 9.0.4 - PAYG Bundle 2

FW_Image  = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries"


Management_Subnet_CIDR = "10.0.0.0/24"

Untrust_Subnet_CIDR = "10.0.1.0/24"

Trust_Subnet_CIDR = "10.0.2.0/24"

FW_Machine_Type = "n1-standard-4"