# fw_license                   = # "byol" #"bundle1" # "bundle2"
fw_bootstrap_storage_account = ""
fw_bootstrap_access_key      = ""
fw_bootstrap_file_share      = ""
fw_bootstrap_share_directory = "None"

# -----------------------------------------------------------------------
prefix = ""

location                     = "eastus"
resource_group_name          = "transit-rg"
vnet_name                    = "vmseries-vnet"
vnet_cidr                    = "10.0.0.0/16"
subnet_names                 = ["mgmt", "untrust", "trust"]
subnet_cidrs                 = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

fw_names                     = ["vmseries-fw1", "vmseries-fw2"]
fw_nsg_prefix                = "0.0.0.0/0"
fw_avset_name                = "vmseries-avset"
fw_panos                     = "latest"
fw_username                  = "paloalto"
fw_password                  = "PanPassword123!"

public_lb_name               = "public-lb"
internal_lb_name             = "internal-lb"
internal_lb_address          = "10.0.2.100"

spoke_user                   = "paloalto"
spoke_password               = "PanPassword123!"
spoke_udrs                   = ["0.0.0.0/0", "10.1.0.0/16", "10.2.0.0/16"]

spoke1_rg                    = "spoke1-rg"
spoke1_vnet_name             = "spoke1-vnet"
spoke1_vnet_cidr             = "10.1.0.0/16"
spoke1_subnet_cidrs          = ["10.1.0.0/24"]
spoke1_vms                   = ["spoke1-vm"]

spoke2_rg                    = "spoke2-rg"
spoke2_vnet_name             = "spoke2-vnet"
spoke2_vnet_cidr             = "10.2.0.0/16"
spoke2_subnet_cidrs          = ["10.2.0.0/24"]
spoke2_vms                   = ["spoke2-vm"]
