project_id      = "<GCP Project ID>"
auth_file       = "<Path to JSON Auth File>"
public_key_path = "<Path to SSH key>"   # Your SSH Key

#fw_panos        = "byol-904"              # Uncomment for PAN-OS 9.0.4 - BYOL
fw_panos        = "bundle1-904"           # Uncomment for PAN-OS 9.0.4 - PAYG Bundle 1
#fw_panos        = "bundle2-904"           # Uncomment for PAN-OS 9.0.4 - PAYG Bundle 2


#-------------------------------------------------------------------
region          = "us-central1"

vpc0            = "testing"
vpc0_subnet     = "testing-subnet"
vpc0_cidr       = "10.30.1.0/24"

vpc1            = "mgmt"
vpc1_subnet     = "mgmt-subnet"
vpc1_cidr       = "10.60.1.0/24"

vpc2            = "production"
vpc2_subnet     = "production-subnet"
vpc2_cidr       = "10.50.1.0/24"

vpc3            = "production2"
vpc3_subnet     = "production2-subnet"
vpc3_cidr       = "10.40.1.0/24"

fw_base_name    = "vmseries"
fw_machine_type = "n1-standard-4"
target_size     = "1"

mgmt_sources    = ["0.0.0.0/0"]
health_check_port = "22"
all_ports         = true

server_user       = "demo"
server_size       = "f1-micro"
server_image      = "ubuntu-os-cloud/ubuntu-1604-lts"
server_public_ip  = true
server1_vms       = ["testing-vm"]
server1_ips       = ["10.30.1.100"]

server2_vms       = ["production-vm"]
server2_ips       = ["10.50.1.100"]

ilb1_ip           = "10.30.1.99"
ilb2_ip           = "10.50.1.99"
