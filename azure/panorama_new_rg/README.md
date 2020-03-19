# Azure Panorama

Terraform creates an instance of Panorama in a new Resource Group.

## Prerequistes 
* Valid Azure Subscription
* Access to Azure Cloud Shell

## Caveats
You will need to determine the available versions of Panorama using the Azure CLI. The following command will show the Panorama versions currently available 

bash-4.3# az vm image list -p paloaltonetworks -f panorama --all
```
[
  {
    "offer": "panorama",
    "publisher": "paloaltonetworks",
    "sku": "byol",
    "urn": "paloaltonetworks:panorama:byol:8.1.0",
    "version": "8.1.0"
  },
  {
    "offer": "panorama",
    "publisher": "paloaltonetworks",
    "sku": "byol",
    "urn": "paloaltonetworks:panorama:byol:8.1.2",
    "version": "8.1.2"
  },
  {
    "offer": "panorama",
    "publisher": "paloaltonetworks",
    "sku": "byol",
    "urn": "paloaltonetworks:panorama:byol:9.1.1",
    "version": "9.1.1"
  }
]
```
## How to Deploy
### 1. Setup & Download Build
In the Azure Portal, open Azure Cloud Shell and run the following command (**BASH ONLY!**):
```
# Accept VM-Series EULA for desired currently-available version of Panorama (see above command for urn)
$ az vm image terms accept --urn paloaltonetworks:panorama:byol:8.1.2

# Download repo & change directories to the Terraform build
$ git clone https://github.com/wwce/terraform; cd terraform/azure/panorama_new_rg
```

### 2. Edit variables.tf or create terraform.tfvars
The variables.tf file contains default settings for the template. It may be edited to suit specific requirements or the file terraform.tfvars.sample can be used to create a terraform.tfvars file to override some or all settings.

Variable descriptions:

	virtualMachineRG = Name of resource group to create

	Location = Target Azure region

	virtualNetworkName = Virtual Network Name

	addressPrefix = VNet CIDR

	subnetName = Subnet name in the VNet

	subnet = Subnet CIDR

	publicIpAddressName = Panorama public IP address name

	networkInterfaceName = Panorama network interface name

	networkSecurityGroupName = Network Security Group (NSG) name

	diagnosticsStorageAccountName = Diagnostics Storage Account name

	diagnosticsStorageAccountTier = Diagnostics Storage Account tier

	diagnosticsStorageAccountReplication = Diagnostics Storage Account replication

	virtualMachineName = Panorama VM name

	virtualMachineSize = Panorama VM size

	panoramaVersion = Panorama Version

	adminUsername = Admin Username

	adminPassword = Admin Password


### 3. Deploy Build
```
$ terraform init
$ terraform apply
```

</br>

## How to Destroy
Run the following to destroy the build.
```
$ terraform destroy
```

</br>

## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
