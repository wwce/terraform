## Transit Architecture: Common Firewall with 2 Spoke VNETs
This is a Terraform build that creates a transit VNET with VM-Series firewalls (2) to secure north-south and east-west traffic for 2 spoke VNETs connected to the transit via VNET peering.

<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/azure/transit-common-fw/diagram.png">
</p>

### Overview
The following resources are deployed  Deployment resources can be added & removed from the **main.tf** inside the root directory.
* 3 x Virtual Networks (transit, spoke1, spoke2)
    * Transit VNET has 3 subnets (mgmt, untrust, trust)
    * Test subnets are deployed into each spoke VNET
    * An Azure route table is created in each spoke VNET with a default UDR to the firewall's internal load balancer
* 2 x VM-Series NGFW 
    * ***NOTE:*** The number of firewalls deployed is determined by the number of values entered into the fw_names variable (default: 2)
    * All firewalls deployed will belong into a new availability set
    * Each firewall will have 3 x interfaces
        * management: `<fw_name>-nic0`
            * NSG: `<nsg_name>-mgmt`
            * Public IP Address: `<fw_name>-nic0-pip`
            * Accelerated Networking (optional)
        * dataplane1: `<fw_name>-nic1`
            * NSG: `<nsg_name>-data` 
            * Public IP Address: `<fw_name>-nic1-pip`
            * Accelerated Networking
        * dataplane2: `<fw_name>-nic2`
            * NSG: `<nsg_name>-data`  
    * Managed Disks
    * BYOL/Bundle1/Bundle2 License
* 1 x Standard SKU Public Load Balancer
    *  Backend Pool: `<fw_name>-nic1`
* 1 x Standard SKU Internal Load Balancer with HA Ports
    *  Backend Pool: `<fw_name>-nic2`

### Prerequisites 
1. Terraform (v11)
2. Azure Subscription with sufficient privileges
3. (Optional) An existing Azure Storage Account to bootstrap the firewalls with the files located in /bootstrap_files (do not use for production deployments)
    * Bootstrap Credentials
        * UN: paloalto
        * PW: PanPassword123!
4.  Adjust values in variables.tf to meet your deployment requirements.

### How to Deploy
1.  Launch Terraform build.
2.  Log into the firewall's using the IP assigned to `<fw_name>-nic0`

### Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
