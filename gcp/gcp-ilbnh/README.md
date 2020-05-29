# gcp-ilbnh
ILB as next hop in GCP\
This repository is intended to be used in conjunction with the 2-spoke advanced peering demo template:

https://github.com/wwce/terraform/tree/master/gcp/adv_peering_2fw_2spoke

This template may be used simultaneouly with or subsequent to the advanced peering template and will create an additional pair of FW behind an internal load balancer that can be used for outbound loadbalancing of TCP (only) traffic to provide redundancy of outbound connectivity. 

ILB as next hop is not currently GA. Consequently, routes will need to be modified post-deployment with the following gcloud CLI command:

gcloud beta compute routes create default-ilbnh \\ \
--network=trust-vpc \\ \
--destination-range=0.0.0.0/0 \\ \
--next-hop-ilb=ilbnh-all  \\ \
--next-hop-ilb-region=\<GCP REGION\> \\ \
--priority=99

N.B. - This template was developed/tested using Terraform 0.11.

## Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
