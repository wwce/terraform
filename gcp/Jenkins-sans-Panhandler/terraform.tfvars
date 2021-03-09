#Billing_Account = "<billing Account Number>"

# Uncomment the following three lines for the original Jenkins demo
#HC_Request_Path = "/" 
#Server_Initscript_Path = "scripts/initialize_webserver.sh"
#Attacker_Initscript_Path = "scripts/initialize_attacker.sh"

# Uncomment the following three lines for the struts2 demo
HC_Request_Path = "/showcase.action"
Server_Initscript_Path = "scripts/initialize_struts.sh"
Attacker_Initscript_Path = "scripts/initialize_kali.sh"

# Uncomment the following three lines to use dvwa
#HC_Request_Path = "/login.php"
#Server_Initscript_Path = "scripts/initialize_dvwa.sh"
#Attacker_Initscript_Path = "scripts/initialize_kali.sh"

Public_Key = "ssh-rsa <key material> <user-name>"

# No changes should be required below this point

Red_Team_Name = "red-team"

Blue_Team_Name = "blue-team"

GCP_Region = "us-central1"

GCP_Zone = "us-central1-a"

Management_Subnet_CIDR = "10.0.0.0/24"

Untrust_Subnet_CIDR = "10.0.1.0/24"

Trust_Subnet_CIDR = "10.0.2.0/24"

Attacker_Subnet_CIDR = "10.1.1.0/24"

FW_Mgmt_IP = "10.0.0.10"

FW_Untrust_IP = "10.0.1.10"

FW_Trust_IP = "10.0.2.10"

WebLB_IP = "10.0.2.30"

Webserver_IP1 = "10.0.2.50"

Webserver_IP2 = "10.0.2.60"

Attacker_IP = "10.1.1.50"

Content_Bucket = "security-framework-content"
