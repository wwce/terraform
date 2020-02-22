#fw_license   = "byol"                                                       # Uncomment 1 fw_license to select VM-Series licensing mode
#fw_license   = "bundle1"
#fw_license   = "bundle2"

global_prefix = ""                                                           # Prefix to add to all resource groups created.  This is useful to create unique resource groups within a shared Azure subscription
location      = "centralus"

# -----------------------------------------------------------------------
# VM-Series resource group variables

fw_prefix               = "vmseries"                                         # Adds prefix name to all resources created in the firewall resource group
fw_count                = 2
fw_panos                = "9.0.1"
fw_nsg_prefix           = "0.0.0.0/0"
fw_username             = "paloalto"
fw_password             = "Pal0Alt0@123"
fw_internal_lb_ip       = "10.0.2.100"

# -----------------------------------------------------------------------
# Transit resource group variables

transit_prefix          = "transit"                                         # Adds prefix name to all resources created in the transit vnet's resource group
transit_vnet_cidr       = "10.0.0.0/16"
transit_subnet_names    = ["mgmt", "untrust", "trust","gateway"]
transit_subnet_cidrs    = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

# -----------------------------------------------------------------------
# Spoke resource group variables

spoke1_prefix           = "spoke1"                                          # Adds prefix name to all resources created in spoke1's resource group
spoke1_vm_count         = 2
spoke1_vnet_cidr        = "10.1.0.0/16"
spoke1_subnet_cidrs     = ["10.1.0.0/24"]
spoke1_internal_lb_ip   = "10.1.0.100"

spoke2_prefix           = "spoke2"                                          # Adds prefix name to all resources created in spoke2's resource group
spoke2_vm_count         = 1
spoke2_vnet_cidr        = "10.2.0.0/16"
spoke2_subnet_cidrs     = ["10.2.0.0/24"]

spoke_username          = "paloalto"
spoke_password          = "Pal0Alt0@123"
spoke_udrs              = ["0.0.0.0/0", "10.1.0.0/16", "10.2.0.0/16"]
