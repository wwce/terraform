## 2 x VM-Series / Transit Gateway / 2 x Spokes VPCs
Credit for this Terraform build goes to **djspears**.  This build contains the following modifiations of [djspears build](https://github.com/wwce/terraform/tree/master/aws/TGW-VPC).
1. Spoke-to-Internet traffic explicitly flows through firewall-1 (no SNAT).  
2. Spoke-to-Spoke traffic explicitly flows through firewall-2 (no SNAT).
3. Creation of dedicated route tables for each subnet (main route table is not used).

### Diagram
This Terraform build deploys the following architecture:
</br>
<p align="center">
<img src="https://raw.githubusercontent.com/wwce/terraform/master/aws/tgw_2fw_vpc_insertion/diagram.png">
</p>

### VM-Series Overview
* Firewall-1 handles egress traffic to internet
* Firewall-2 handles east/west traffic between Spoke1-VPC and Spoke2-VPC
* Both Firewalls can handle inbound traffic to the spokes
* Firewalls are bootstrapped off an S3 Bucket (buckets are created during deployment)

### S3 Buckets Overview
* 2 x S3 Buckets are deployed & configured to bootstrap the firewalls with a fully working configuration.
* The buckets names have a random 30 string added to its name for global uniqueness `tgw-fw#-bootstrap-<randomString>`

## How to Deploy
1.  Download the tgw_2fw_vpc_insertion directory.
2.  In an editor, open 'variables.tf'
    *  Line 10:  Set your existing AWS EC2 Key 
    *  Line 14:  Enter a source address to access the VM-Series management interface.  This address will be added to the management interface's Network Security Group.
    *  Line 17:  Uncomment either 'byol', 'payg1', or 'payg2'.  This sets the licensing for both VM-Series firewalls (bring-your-own-license, bundle1, or bundle2).  

 NOTE: 
 ``` 
 1. This assumes that the AWS CLI is installed on the machine doing the deploymnet.  If AWS CLI is not installed, the providers.tf must be changed to include your AWS Access Key and Secret Key [(more info)](https://www.terraform.io/docs/providers/aws/index.html).
 3. Here is a link to setting up a creds file to access AWS: 
       https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html
 4. After deployment the firewall username and password are:
         Username: paloalto
         Password: Pal0Alt0@123

 ```

 This is a screenshot of the output once the deployment has completed that shows how to connect to the various components:

![tgwout](https://user-images.githubusercontent.com/21991161/53307965-1793f100-3863-11e9-8eaa-fabeb35d7cda.jpg)


 # Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself.
Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.

 # License


 Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at                                                  

   http://www.apache.org/licenses/LICENSE-2.0                           

 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  
