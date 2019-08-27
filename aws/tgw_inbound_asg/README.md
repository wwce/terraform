## VM-Series Autoscaling for Inbound TGW
This build is an adaptation of the [AWS VM-Series Autoscaling 2.0](https://docs.paloaltonetworks.com/vm-series/8-1/vm-series-deployment/set-up-the-vm-series-firewall-on-aws/auto-scale-vm-series-firewalls-with-the-amazon-elb/autoscale-template-version2_0.html) to work function with AWS Transit Gateway.

### Overview
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/aws-cft/master/tgw_inbound_asg/diagram.png">
</p>

### Requirements
* An existing Transit Gateway
* An existing Transit Gateway route table for the Spoke-VPC attachment (application VPC)
* An existing Transit Gateway route table for the Security-VPC attachment
* S3 Bucket for VM-Series bootstrap
* S3 Bucket for Lambda code


### How to Deploy
1.  Review [AWS VM-Series Autoscaling 2.0](https://docs.paloaltonetworks.com/vm-series/8-1/vm-series-deployment/set-up-the-vm-series-firewall-on-aws/auto-scale-vm-series-firewalls-with-the-amazon-elb/autoscale-template-version2_0.html)
2.  Follow the **guide.pdf** for additional instructions.  


## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
