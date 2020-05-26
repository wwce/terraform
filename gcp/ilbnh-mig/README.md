## MultiNic ILB Deployment
This is a Terraform version of the manual build described at:
https://cloud.google.com/load-balancing/docs/internal/setting-up-ilb-next-hop

Terraform creates a VM-Series firewall that secures egress and east-west traffic for 2 internal VPCs.  Egress traffic from the internal VPCs is routed via the Load Balancer as Next Hop to the VM-Series. The FW is deployed via a Managed Instance Group to allow for automatic failure detection/repacement. 

### Overview
* 4 x VPCs (testing,management,production, production2)
* 1 x VM-Series (BYOL / Bundle1 / Bundle2) in a Managed Instance Group
* 1 x Ubuntu VM in the testing VPC (install Apache during creation)
* 1 x Ubuntu VM in the production VPC (install Apache during creation)
* 1 x GCP Internal Load Balancer in the testing VPC
* 1 x GCP Internal Load Balancer in the production VPC
* 1 x GCP Storage Bucket for VM-Series bootstrapping (random string appended to bucket name for global uniqueness)
</br>
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/gcp/ilbnh-mig/images/diagram.svg" width="550">
</p>


### Prerequistes 
1. Terraform
2. Access to GCP Console

After deployment, the firewalls' username and password are:
     * **Username:** paloalto
     * **Password:** Pal0Alt0@123

### Deployment
1.  Download the **ilbnh-mig** repo to the machine running the build
2.  In an editor, open **terraform.tfvars** and set values for the following variables

| Variable        | Description |
| :------------- | :------------- |
| `project_id` | Project ID for the VM-Series, VM-Series VPCs, GCP storage bucket, & public load balancer. |
| `public_key_path` | Public key used to authenticate to the FW (username: admin) and the Ubuntu VMs (username:demo) |
| `fw_panos` | The species and version of the FW to deploy |
| `auth_file`| Authentication key file for deployment |

3.  Download project authenication key files to the main directory of the terraform build.
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/gcp/ilbnh-mig/images/directory.png" width="550">
</p>

4. Execute Terraform
```
$ terraform init
$ terraform plan
$ terraform apply
```

5. After the deployment finishes, navigate to the console and not the public IP address associated with one of the ubuntu servers.

<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/gcp/ilbnh-mig/images/deployment.png" width="550">
</p>

6. Connect to the server and issue the curl command to its peer.

<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/gcp/ilbnh-mig/images/curl.png" width="550">
</p>

7. Login to the FW and note the traffic logs.
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/gcp/ilbnh-mig/images/fwlogs.png" width="550">
</p>

8. Destroy the envirnment when done.
```
$ terraform destroy
```

## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
