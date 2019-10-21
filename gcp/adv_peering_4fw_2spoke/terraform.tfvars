#project_id      = ""
#public_key_path = "~/.ssh/gcp-demo.pub"

#fw_panos        = "byol-904"
#fw_panos        = "bundle1-904" 
#fw_panos        = "bundle2-904"


#-------------------------------------------------------------------
region            = "us-east4"

mgmt_vpc          = "mgmt"
mgmt_subnet       = ["mgmt"]
mgmt_cidr         = ["192.168.0.0/24"]
mgmt_sources      = ["0.0.0.0/0"]

untrust_vpc       = "untrust"
untrust_subnet    = ["untrust"]
untrust_cidr      = ["192.168.1.0/24"]

trust_vpc         = "trust"
trust_subnet      = ["trust"]
trust_cidr        = ["192.168.2.0/24"]

spoke1_vpc        = "spoke1"
spoke1_subnets    = ["spoke1-web"]
spoke1_cidrs      = ["10.10.1.0/24"]
spoke1_vms        = ["spoke1-vm1", "spoke1-vm2"]
spoke1_ilb        = "spoke1-ilb"
spoke1_ilb_ip     = "10.10.1.100"

spoke2_vpc        = "spoke2"
spoke2_subnets    = ["spoke2-db"]
spoke2_cidrs      = ["10.10.2.0/24"]
spoke2_vms        = ["spoke2-vm1"]
spoke_user        = "demo"

fw_names_inbound  = ["vmseries01", "vmseries02"]
fw_names_outbound = ["vmseries03", "vmseries04"]
fw_machine_type   = "n1-standard-4"

glb_name          = "vmseries-glb"
ilb_name          = "vmseries-ilb"

