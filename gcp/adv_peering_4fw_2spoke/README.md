## 4 x VM-Series / 2 x Spoke VPCs via Advanced Peering / ILBNH

Terraform creates 4 VM-Series firewalls that secure ingress/egress traffic from spoke VPCs.  The spoke VPCs are connected (via VPC Peering) to the VM-Series trust VPC. All TCP/UDP traffic originating from the spokes is routed to the internal load balancers.

Please see the deployment guide [**Deployment Guide**](https://github.com/wwce/terraform/blob/master/gcp/adv_peering_4fw_2spoke/guide.pdf). for more information.

### Diagram
</br>
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/gcp/adv_peering_4fw_2spoke/diagram.png">
</p>


### Prerequistes 
1. Valid GCP Account

### How To
Setup Project (all commands are run from Google Cloud Terminal or from local machine with terraform v12.0 installed)
```
	$ gcloud services enable compute.googleapis.com
	$ ssh-keygen -f ~/.ssh/<keyname> -t rsa -C <comment>
	$ git clone https://github.com/wwce/terraform; cd terraform/gcp/adv_peering_4fw_2spoke
```

Run Build
```
	# Edit terraform.tfvars to match project ID, SSH Key, and PAN-OS version and license.

	$ terraform init
	$ terraform apply
```

Destroy Build
```
	$ terraform destroy
```

## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
