# 2 x VM-Series / Internal LB / Public LB / 2 x Spoke VPCs

Terraform creates 2 VM-Series firewalls that secure ingress/egress traffic from spoke VPCs.  The spoke VPCs are connected (via VPC Peering) to the VM-Series trust VPC. All TCP/UDP traffic originating from the spokes is routed to internal load balancers.

Please see the [**Deployment Guide**](https://github.com/wwce/terraform/blob/master/gcp/adv_peering_2fw_2spoke_common/guide.pdf) for more information.

</br>
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/gcp/adv_peering_2fw_2spoke_common/images/diagram.png">
</p>


## Prerequistes 
* Valid GCP Account with Project
* Access to GCP Cloud Terminal or to a machine with a Terraform 12 installation

## How to Deploy
### Setup
1. In your project, open GCP Cloud Terminal and run the following.
```
	$ gcloud services enable compute.googleapis.com
	$ ssh-keygen -f ~/.ssh/gcp-demo -t rsa -C gcpdemo
	$ git clone https://github.com/wwce/terraform; cd terraform/gcp/adv_peering_2fw_2spoke_common
```


2. Open terraform.tfvars
```
	$ vi terraform.tfvars
```


3.  Set values for your Project ID, SSH Key (from step 1), and the VM-Series PAN-OS version and license type. 
```
project_id      = "my-project-id-012345"    # Your project ID for the deployment
public_key_path = "~/.ssh/gcp-demo.pub"     # Your SSH Key

#fw_panos        = "byol-904"               # Uncomment for PAN-OS 9.0.4 - BYOL
fw_panos        = "bundle1-904"             # Uncomment for PAN-OS 9.0.4 - PAYG Bundle 1
#fw_panos        = "bundle2-904"            # Uncomment for PAN-OS 9.0.4 - PAYG Bundle 2
```

### Deploy
```
	$ terraform init
	$ terraform apply
```

### 3. Clean Up
Run the following to destroy the build.
```
	$ terraform destroy
	$ rm ~/.ssh/gcp-demo*
```

## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
