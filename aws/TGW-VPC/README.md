# Transit Gateway Deployment for North/South and East/West Inspection 

 This terraform template will deploy a complete Transit Gateway(TGW) solution with Palo Alto Networks VM-Series Firewalls to inspect both N/S and E/W traffic. The follow diagram shows what will be deployed:

![tgw-vpc](https://user-images.githubusercontent.com/21991161/53307956-ff23d680-3862-11e9-9fd1-49cbacb696ea.jpg)


 This is a quick overview of what components are deployed
```
1.  Security VPC that includes 2 firewalls in seperate AZs.
2.  The template will create 2 S3 buckets used for bootstrapping the firewall configuration. Do not create the S3 buckets manually.
3.  Two Spoke VPCs.  Each with two subnets and 1 ubuntu server deployed in it.
4.  TGW with attachments and routing to support N/S and E/W traffic through the firewalls.
```

 NOTE: 
 ``` 
 1. There are some things that should be changed in the Variables.tf file.  They are labeled at the top of the file.
 2. This assumes that the AWS CLI is installed on the machine doing the deploymnet
 3. Here is a link to setting up a creds file to access AWS: 
       https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html
 4. After deployment the firewall username and password are:
         Username: admin
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
