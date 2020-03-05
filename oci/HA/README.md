# Sample HA deployment for OCI

Terraform creates:
- A single compartment to house all infrastructure
- A VCN with 5 regional subnets (management, untrust, trust, ha2, web)
- 2 VM-Series firewalls in separate Availability Domains (ADs)
- A test server
- OCI Dynamic Groups and Policies for secondary IP address management

HA in OCI works by moving secondary IP addresses from the down FW to the newly-active one. This is accomplished by the VM-Series plugin avilable beginning with PANOS 9.1.1 in OCI.

</br>
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/oci/HA/OCI-HA.png">
</p> 

Prior to deployment, update terraform.tfvars with the following information:
- tenancy_ocid - The OCID of the target tenancy
- user_ocid - The OCID of the user deploying the infrastructure
- fingerprint - The fingerprint associated with the user's API key
- private_key_path - The absolute path to the PEM-formatted private SSH key for the user
- parent_compartment_ocid - The OCID of the parent/root compartment
- ssh_authorized_key - The public SSH key for the user (format = "ssh-rsa <key> <username>")
- fw_mgmt_src_ip - The IP or subnet authorized to connect to the FW post-deployment

By default, the deployment is into us-ashburn-1. This may be altered by changing the relevant variables in terraform.tfvars.

The folder fw-config contains sample configuration files for the FW. These configuration files have HA pre-configured, allow SSH access to the server, and permit all outbound access to the internet. The username is 'admin' and the password is 'Pal0Alt0@123', which should be changed immediately.

## Support Policy
These files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
