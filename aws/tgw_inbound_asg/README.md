## VM-Series Autoscaling for Inbound TGW
This build is an adaptation of the [AWS VM-Series Autoscaling 2.0](https://docs.paloaltonetworks.com/vm-series/8-1/vm-series-deployment/set-up-the-vm-series-firewall-on-aws/auto-scale-vm-series-firewalls-with-the-amazon-elb/autoscale-template-version2_0.html) to work function with AWS Transit Gateway.

### Overview
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/aws/tgw_inbound_asg/diagram.png">
</p>

### Requirements
* Existing Transit Gateway
* Existing Transit Gateway route table for the Security-VPC attachment
* EC2 Key Pair for deployment region
* UN/PW: **pandemo** / **demopassword**


### How to Deploy
1.  Open **variables.tf** in a text editor. 
2.  Uncomment default values and add correct value for following variables: 
    * **fw_ami**
         * Firewall AMI for AWS Region, SKU, & PAN-OS version.
    * **fw_sg_source**
         * Source prefix to apply to VM-Series mgmt. interface
    * **tgw_id** 
         * Existing Transit Gateway ID
    * **tgw_rtb_id** 
         * Existing Transit Gateway Route Table ID
3.  Save **variables.tf**
4.  BYOL ONLY 
    * If you want to license the VM-Series on creation, copy and paste your Auth Code into the /bootstrap/authcodes file.  The Auth Code must be registered with your Palo Alto Networks support account before proceeding.
Before proceeding, make sure you have accepted and subscribed to the VM-Series software in the AWS Marketplace. 



## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
