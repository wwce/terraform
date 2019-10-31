## 4 x VM-Series / 2 x Spoke VPCs via Advanced Peering / ILBNH

Terraform creates 4 VM-Series firewalls that secure ingress/egress traffic from spoke VPCs.  The spoke VPCs are connected (via VPC Peering) to the VM-Series trust VPC. All TCP/UDP traffic originating from the spokes is routed to the internal load balancers.

### Overview
* 5 x VPCs (mgmt, untrust, trust, spoke1, & spoke2) with relevant peering connections
* 2 x VM-Series (BYOL / Bundle1 / Bundle2)
* 2 x Ubuntu VM in spoke1 VPC (install Apache during creation)
* 1 x Ubuntu VM in spoke2 VPC
* 1 x GCP Public Load Balancer (VM-Series as backend)
* 3 x GCP Internal Load Balancer
  * Spoke1
  * Default (handles outbound to internet)
  * East-West (handles lateral traffic between spoke1 and spoke2)
* 2 x GCP Bootstrap Buckets
</br>
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/gcp/adv_peering_2fw_2spoke/images/diagram.png" width="250">
</p>


### Prerequistes 
1. Valid GCP Account

After deployment, the firewalls' username and password are:
     * **Username:** paloalto
     * **Password:** Pal0Alt0@123

### How To

*Step 1.*  Setup Project (all commands are run from Google Cloud Terminal or from local machine with terraform v12.0 installed)
```
	$ gcloud services enable compute.googleapis.com
	$ ssh-keygen -f ~/.ssh/<keyname> -t rsa -C <comment>
	$ git clone https://github.com/wwce/terraform; cd terraform/gcp/adv_peering_4fw_2spoke
```

*Step 2.* Run Build
```
	# Edit terraform.tfvars to match project ID, SSH Key, and PAN-OS version and license.

	$ terraform init
	$ terraform apply
```

*Part 3* Destroy Build
```
	$ terraform destroy
```

## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
