
# ---------------------------------------------------------------------------------------------------------------------
# MANDATORY PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

access_key = "<AWS Access Key"
secret_key = "AWS Secret Key"
public_key = "ssh-rsa <RSA-Publice-Key>"

# ---------------------------------------------------------------------------------------------------------------------
# LESS MANDATORY PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
# Note: When this was created GWLB was not in all regions.  It was in US-West-2 so that is why
#       I left this information here.  If you change be sure to get the 10.0.2 AMI as that is the 
#       version that is supporting GENEVE.
region = "us-west-2"
firewall_ami_id = "ami-07b138a2ba5797078"
availability_zones = ["us-west-2b", "us-west-2c"]
app_stack1_availability_zone = "us-west-2b"
app_stack2_availability_zone = "us-west-2c"
vpc_cidr = "10.10.0.0/16"
app1_vpc_cidr = "10.101.0.0/16"
app2_vpc_cidr = "10.102.0.0/16"
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
user_data="vmseries-bootstrap-aws-s3bucket=<S3 Bucket Name>"
