## 2 x VM-Series / NLB for VPC Mirror
Terraform creates 2 VM-Series firewalls that are targets of an internal load balancer ready to receive VXLAN traffic from a VPC Mirroring configuration.   After deployment there are some steps that need to be done to setup VPC traffic Mirroring.  Those are documenented in screen shots below.

### Overview
* 1 x VPC 
* 2 x VM-Series (Bundle2)
* 1 x NLB Internal Load Balancer listening on VXLAN UDP Port 4789 (NGFW 3 & 4 as targets)
* 2 x S3 Buckets for VM-Series 

This is picture of the deployed environment:


![deployment](https://user-images.githubusercontent.com/21991161/65703297-271e2700-e04a-11e9-9827-5512629c6db0.jpg)


### Prerequistes 
1. Terraform
2. Access to AWS Console

After deployment, the firewalls' username and password are:
     * **Username:** admin
     * **Password:** Pal0Alt0@123

### Deployment
1.  Download the **TGW-VPC-Mirroring** repo to the machine running the build
2.  In an editor, open **variables.tf** and set values for the following variables

| Variable        | Description |
| :------------- | :------------- |
| `aws_region` | AWS Region of Deployment|
| `aws_key` | Authentication key file for deployed VMs |
| `bootstrap_s3bucket3` | Universally unigue name for Boostrap S3 Bucket for NGFW3 |
| `bootstrap_s3bucket4` | Universally unigue name for Boostrap S3 Bucket for NGFW4 |
| 

3. Execute Terraform
```
$ terraform init
$ terraform plan
$ terraform apply
```

5. After deployment an output with connection information will be displayed:
![Output](https://user-images.githubusercontent.com/21991161/65703240-12419380-e04a-11e9-9dc4-4a89231fc857.jpg)

6. To configure VPC Mirroring first select VPC/Traffic Mirroring/Mirror Filter and Create a new traffic mirror filter

![Mirrorfilterselection](https://user-images.githubusercontent.com/21991161/65637508-eb338500-dfa9-11e9-893b-1255ed2f7135.jpg)" width="350">


7. Fill in the fields and click create
![MirrorFilterOptions](https://user-images.githubusercontent.com/21991161/65637506-eb338500-dfa9-11e9-9453-c9a32bf9f276.jpg)

8. Next select VPC/Traffic Mirror/Mirror Targets and click Create a Mirror Target
![Mirrortargetselection](https://user-images.githubusercontent.com/21991161/65637512-ebcc1b80-dfa9-11e9-9d27-a50ac1698ad3.jpg)


9. Fill in the fields and click create
![MirrorTargetoptions](https://user-images.githubusercontent.com/21991161/65637511-eb338500-dfa9-11e9-82b4-65cedbdeea71.jpg)

10. Select VPC/Traffic Mirror/Mirror Sessions and click Create a Mirror Session
![MirrorSessionSelection](https://user-images.githubusercontent.com/21991161/65637510-eb338500-dfa9-11e9-9966-b4f5d1b279ca.jpg)

11. Fill in the fields and click create
![mirrorsessionoptions](https://user-images.githubusercontent.com/21991161/65637509-eb338500-dfa9-11e9-87c9-fdfdb3a6a738.jpg)

## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
