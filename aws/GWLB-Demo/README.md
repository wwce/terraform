# Palo Alto Networks VM-Series Integration with AWS Gateway Load Balancer

This package will help you deploy a full AWS Gateway Load Balancer demonstration environment that leverages the Palo Alto Networks VM-Series NGFWs to show how this solutions secures your Inbound, Outbound and East-West traffic.  This demo will also create a Transit Gateway that is used for E/W and outbound traffic.

This deployment is meant to delploy a complete GWLB environment integrated with a TGW and 2 spoke Application VPCS.  This repo is based on the following PANW repo that provides the ability to deploy just the GWLB independantly: 

https://github.com/PaloAltoNetworks/AWS-GWLB-VMSeries

Here is a diagram of what gets deployed with this Repo:

<br />
<br />
<br />
<br />
<img src="https://github.com/PaloAltoNetworks/AWS-GWLB-VMSeries/raw/main/terraform/topology.png"/>
<br />
<br />
<br />
## Table of Contents

1. Prerequisites

2. Deployment

3. Verify Traffic Inspection On VM-Series (Optional)

3. Support


<br />
<br />

--------

<br />
<br />

## Prerequisites

1. Install Python 3.6.10
	- Confirm the installation 
	
	`python3 --version`
	- This should point to Python 3.6
2. Install Terraform 0.12
    - Confirm the installation
    
    `terraform version`
    - This should point to Terraform v0.12.x
3. Install the python requirements
	- `pip3 install --upgrade -r requirements.txt`
4. Create a local ssh keypair to access instances deployed by this terraform deployment.
	- Private Key: `openssl genrsa -out private_key.pem 2048`
	- Change Permissions: `chmod 400 private_key.pem`
	- Public Key: `ssh-keygen -y -f private_key.pem > public_key.pub`
5. In my personal deployment of this I am using a S3 bucket to bootstrap the NGFWs and using a Device Group and Template in Panorama to provide all the firewall configuration.  I included in the repo a santized copy of my init.cfg and sample NGFW configuration in the bootstrap.xml.  The bootstrap.xml is from version 10.0.0.2. The admin username and password is pandemo/Pal0Alt0@123.  You could use the bootstrap.xml to get a config on the NGFW and import into Panorama for future deployments.

**With this, your environment is now ready to deploy VM-Series in integration with AWS Gateway Load Balancer.** 

<br />
<br />

## Deploy Security Stack

1. Setup the variables needed for deployment.  This template could be deploy with just changing the Mandatory Parameters:
    1. AWS access Key(Mandatory) `access_key`:
        
    2. AWS Secret Key(Mandatory) `secret_key`:
        
    3. Parameter(Mandatory) `public_key`:
        - Use the contents of public key created in Prerequisites Step 4 as parameter value.
        
        Ex. `public_key="ssh-rsa xxxxxxxxxx"`
2. Setup 'Less' Mandatory Parameters:

   Note: When this was created, the GWLB was not in all regions.  It was in US-West-2 so that is why
   I left this information here.  If you change be sure to get the 10.0.2 AMI as that is the 
   version that is supporting GENEVE.
   
3. Setup Optional Parameters: 
   1. Parameter(Optional) `user_data`:
        - Option 1: Enter a Basic Configuration as User Data.
        
        Ex. `user_data="type=dhcp-client\nhostname=PANW\nauthcodes=<Vm-Series Licensing Authcode>"`.
        - Option 2(This is what I did): Use an S3 Bootstrap bucket. 
        
        Ex. `user_data="vmseries-bootstrap-aws-s3bucket=<s3-bootstrap-bucket-name>"`.
        
        If Option 2 is used, please make sure you have the following line in init-cfg.txt file:
        
        `plugin-op-commands=aws-gwlb-inspect:enable`

        A sample init.cfg that is used to connect to Panorama is in the repo
    2. Parameter(Optional) `prefix`:
        - Use this parameter to prefix every resource with this string.
    3. Parameter(Optional) `fw_mgmt_sg_list` and `app_mgmt_sg_list`:
        - Use this parameter to input a list of IP addresses with CIDR from which you want Firewall/App Management to be accessible.
    4. Check out all optional terraform parameters for more functionality. The parameter definitions lie in the file `variables.tf`

4. Deploy Security Stack using Terraform
    - Go to the security stack terraform directory `cd /path/to/GWLB-Demo/`
    - Initialize terraform `terraform init`
    - Apply the template `terraform apply`
    - This will start the deployment
    - You will see the output of the deployment once it is complete.
    - The output will look like:
    ```
    Outputs:
    app1_deployment_id = PANW-702d
    app1_fqdn = app-alb-PANW-702d-1006037643.us-west-2.elb.amazonaws.com
    app1_gwlbe_id = vpce-0b448aa66e9f4ca20
    app1_mgmt_ip = 44.237.53.17
    app2_deployment_id = PANW-2e2a
    app2_fqdn = app-alb-PANW-2e2a-403656353.us-west-2.elb.amazonaws.com
    app2_gwlbe_id = vpce-0600753874e122d2f
    app2_mgmt_ip = 52.12.114.166
    deployment_id = PANW-fc34
    firewall_ip = [
    "44.242.120.182",
    "100.22.9.187",
    ]
    gwlb_arn = arn:aws:elasticloadbalancing:us-west-2:777704464536:loadbalancer/gwy/sec-gwlb-PANW-fc34/10a2b5c00ecf94f1
    gwlb_listener_arn = arn:aws:elasticloadbalancing:us-west-2:777704464536:listener/gwy/sec-gwlb-PANW-fc34/10a2b5c00ecf94f1/e088fa7547d85ed1
    gwlb_tg_arn = arn:aws:elasticloadbalancing:us-west-2:777704464536:targetgroup/sec-gwlb-tg-PANW-fc34/00a7d59ecd1e57c883
    gwlbe_service_id = vpce-svc-0202fc16d9fe37381
    gwlbe_service_name = com.amazonaws.vpce.us-west-2.vpce-svc-0202fc16d9fe37381
    natgw_route_table_id = [
    "rtb-020676f22a8facbf8",
    "rtb-0eade25ebacef532d",
    ]
    sec_gwlbe_ew_id = [
    "vpce-051b5a4278b900275",
    "vpce-024ae5bc34b49841d",
    ]
    sec_gwlbe_ew_route_table_id = [
    "rtb-0d768330404a549e7",
    "rtb-02d3e6a9671ef1e8b",
    ]
    sec_gwlbe_ob_id = [
    "vpce-0669561907f5c2924",
    "vpce-021c8735b38f0c35d",
    ]
    sec_gwlbe_ob_route_table_id = [
    "rtb-03b28f6f2a0c0b9db",
    "rtb-0e52f93fbfe1d47c5",
    ]
    sec_tgwa_route_table_id = [
    "rtb-0fdd0b5b398ab421c",
    "rtb-032431b99b63daa51",
    ]
    tgw_id = tgw-0e795726cb263fd72
    tgw_sec_attach_id = tgw-attach-0e9a741a14687f74b
    tgw_sec_route_table_id = tgw-rtb-08186b91e58b6668a
   ```

5. Wait for VM Series Firewall to boot up. It can take a few minutes based on the `user_data` passed to the terraform.

6. Once ready, login to your firewall:
    - `ssh -i private_key.pem admin@<Firewall IP>`
    - `firewall_ip` can be found in Security Stack deployment output
    - Once you have logged in, you will need to configure your firewall to allow traffic:
        - Configure interface 'ethernet1/1' as layer 3 with DHCP 
        - Configure interface 'ethernet1/1' with a virtual router, zone and interface management profile.
        - This template configures a health checks(TCP over port 80) on the Target Group so configure the interface management profile(for ethernet1/1) on the firewall to accept this traffic.
        - With this, 'ethernet1/1' behaves as both ingress and egress interface.
        - This firewall configuration will allow traffic to flow based on intrazone default policy.
        

**Congratulations! You have successfully deployed the GWLB Demo.**

<br />
<br />

## Inspect Traffic On VM-Series (Optional)

You can now inspect the traffic on VM-Series Firewall:

1. Inbound Traffic Inspection: 
    - Access the Application Web Page from your browser
    - Go to a browser and execute `http://<fqdn>`
    - `app_fqdn` can be found in App Stack deployment output - There are 2 stacks
    - This inbound traffic destined to the application is inspected by the Firewall and can be seen in it.
    
2. Outbound Traffic Inspection:
    - Because of a 0.0.0.0/0 route to the TGW in app server subnet.  Either a Bastion Jump box or adding a route to the IGW for your public address is required to get access to the App Server.

    - If you add a /32 route to the IGW for your Public IP address, then you can login into the Application Instance
    `ssh -i private_key.pem ubuntu@<Application IP>`
    - `app_mgmt_ip` can be found in App Stack deployment output
    - Execute the following command:
    `curl https://www.paloaltonetworks.com`
    - This outbound traffic coming from the application(via Transit Gateway) is inspected by the Firewall and can be seen in it.

3. East-West Traffic Inspection:
    - This deployment created 2 application stacks in 2 seperate zones.  HTTP and SSH are available via the SGs for East-West traffic.  To generate traffic identify the internal Ip address of the second apps server.  
    - Execute the following command:
    `curl http://<APP 2 Private IP>`
    - This East-West traffic coming from the App 1 and destined to App 2 goes via the Transit gateway to be inspected by the Firewall.

4. Inbound, Outbound and East-West Traffic isolation (Advanced):
    - To isolate your inbound, outbound and east-west traffic, you can associate specific endpoints to sub-interfaces.
    - Follow the document to learn more about this feature: [Associate a VPC-Endpoint with a VM-Series Sub-interface](https://docs.paloaltonetworks.com/vm-series/10-0/vm-series-deployment/set-up-the-vm-series-firewall-on-aws/vm-series-integration-with-gateway-load-balancer/integrate-the-vm-series-with-an-aws-gateway-load-balancer/associate-a-vpc-endpoint-with-a-vm-series-interface.html)

**With this you inspected Inbound, Outbound and East-West traffic on the Application with VM-Series Firewall.**

<br />
<br />

--------

## Support

These templates are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. If additional support is needed then please reach out to Palo Alto Networks Professional services. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself. Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
