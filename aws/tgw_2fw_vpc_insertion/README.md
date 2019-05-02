## 2 x VM-Series / Transit Gateway / 2 x Spokes VPCs

This Terraform build deploys the following architecture. 
</br>
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/azure-arm-mclimans/standard_deployments/v1/images/2fw_3nic_avset_intlb_extlb.png">
</p>


### VM-Series Overview
    * Firewall-1 handles egress traffic to internet
    * Firewall-2 handles east/west traffic between Spoke1-VPC and Spoke2-VPC
    * Firewalls are bootstrapped off an S3 Bucket (buckets are created during deployment)
### S3 Buckets Overview
    * 2 x S3 Buckets are deployed & configured to bootstrap the firewalls with a fully working configuration.
    * The buckets names have a random 30 string added to its name for global uniqueness 'tgw-fw#-bootstrap-<randString>'

## How to Deploy

    1.  Download the tgw_2fw_vpc_insertion directory.
    2.  In an editor, open 'variables.tf'
        *  Line 10:  Set your existing AWS EC2 Key 
        *  Line 14:  Enter a source address to access the VM-Series management interface.  This address will be added to the management interface's Network Security Group.
        *  Line 17:  Uncomment either 'byol', 'payg1', or 'payg2'.  This sets the licensing for both VM-Series firewalls (bring-your-own-license, bundle1, or bundle2).  
