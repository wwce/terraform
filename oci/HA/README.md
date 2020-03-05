# Sample HA deployment for OCI

Terraform creates:
- A VCN with 5 regional subnets (management, untrust, trust, ha2, web)
- 2 VM-Series firewalls in separate Availability Domains (ADs)
- A test web server
- OCI Dynamic Groups and Policies for secondary IP address management

HA in OCI works by moving secondary IP addresses from the down FW to the newly-active one. This is accomplished by the VM-Series plugin avilable beginning with PANOS 9.1.1 in OCI.
