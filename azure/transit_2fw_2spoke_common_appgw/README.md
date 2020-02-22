# 2 x VM-Series / Public LB / Internal LB / AppGW / 2 x Spoke VNETs

This is an extension of the Terraform template located at [**transit_2fw_2spoke_common**](https://github.com/wwce/terraform/tree/master/azure/transit_2fw_2spoke_common).

Terraform creates 2 VM-Series firewalls deployed in a transit VNET with two connected spoke VNETs (via VNET peering).  The VM-Series firewalls secure all ingress/egress to and from the spoke VNETs.  All traffic originating from the spokes is routed to an internal load balancer in the transit VNET's trust subnet.  All inbound traffic from the internet is sent through a public load balancer or an application gateway (both are deployed).


Please see the [**Deployment Guide**](https://github.com/wwce/terraform/blob/master/azure/transit_2fw_2spoke_common/GUIDE.pdf) for more information.

</br>

## Prerequistes 
* Valid Azure Subscription
* Access to Azure Cloud Shell
  
</br>

## How to Deploy
### 1. Setup & Download Build
In the Azure Portal, open Azure Cloud Shell and run the following **BASH ONLY!**.
```
# Accept VM-Series EULA for desired license type (BYOL, Bundle1, or Bundle2)
$ az vm image terms accept --urn paloaltonetworks:vmseries1:<byol><bundle1><bundle2>:9.0.1

# Download repo & change directories to the Terraform build
$ git clone https://github.com/wwce/terraform; cd terraform/azure/transit_2fw_2spoke_common
```

### 2. Edit terraform.tfvars
Open terraform.tfvars and uncomment one value for fw_license that matches your license type from step 1.

```
$ vi terraform.tfvars
```

<p align="center">
<b>Your terraform.tfvars should look like this before proceeding</b>
<img src="https://raw.githubusercontent.com/wwce/terraform/master/azure/transit_2fw_2spoke_common/images/tfvars.png" width="75%" height="75%" >
</p>    

### 3. Deploy Build
```
$ terraform init
$ terraform apply
```

</br>

## How to Destroy
Run the following to destroy the build.
```
$ terraform destroy
```

</br>

## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
