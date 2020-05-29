# GlobalProtect in GCP

Terraform creates a basic GlobalProtect infrastructure consisting of 1 Portal and 2 Gateways (in separate Zones) along with two test Ubuntu servers. 

Please see the [**Deployment Guide**](https://github.com/wwce/terraform/blob/master/gcp/GP-NoAutoScaling/GUIDE.pdf) for more information.

</br>
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/gcp/GP-NoAutoScaling/images/GP_in_GCP.png">
</p>


## Prerequistes 
* Valid GCP Account with existing project
* Access to GCP Cloud Terminal or to a machine with a Terraform 12 installation

</br>

## How to Deploy
### 1. Setup & Download Build
In your project, open GCP Cloud Terminal and run the following.
```
$ gcloud services enable compute.googleapis.com
$ ssh-keygen -f ~/.ssh/gcp-demo -t rsa -C gcp-demo
$ git clone https://github.com/wwce/terraform; cd terraform/gcp/GP-NoAutoScaling
```

### 2. Edit terraform.tfvars
Open terraform.tfvars and edit variables (lines 1-4) to match your Billing ID, Project Base Name, SSH Key (from step 1), and Region.


### 3. Deploy Build
```
$ terraform init
$ terraform apply
```

</br>

## How to Destroy
Run the following to destroy the build and remove the SSH key created in step 1.
```
$ terraform destroy
$ rm ~/.ssh/gcp-demo*
```

</br>

## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
