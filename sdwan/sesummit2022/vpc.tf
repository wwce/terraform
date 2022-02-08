resource "aws_vpc" "sdwan-lab-vpc" {
    cidr_block = var.VPC_CIDR
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    enable_classiclink = "false"
    instance_tenancy = "default"
    tags = {
        Name = "sdwan-lab-${var.CUSTOMER_IDENTIFIER}-vpc"
    }
}

resource "aws_subnet" "sdwan-lab-public1" {
    vpc_id = aws_vpc.sdwan-lab-vpc.id
    cidr_block = cidrsubnet(var.VPC_CIDR, 4, 0) // /20 subnet, block #0 of the CIDR divied into /20s
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
        Name = "Public Subnet 1"
    }
}

resource "aws_subnet" "sdwan-lab-mgmt" {
    vpc_id = aws_vpc.sdwan-lab-vpc.id
    cidr_block = cidrsubnet(var.VPC_CIDR, 4, 1) // /20 subnet, block #1 of the CIDR divied into /20s
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
        Name = "Mgmt Subnet"
    }
}

resource "aws_subnet" "sdwan-lab-private" {
    count = var.ENV_COUNT
    vpc_id = aws_vpc.sdwan-lab-vpc.id
    cidr_block = cidrsubnet(var.VPC_CIDR, 12, 514 + var.ENV_START + count.index)
    // /28 subnet, starting at block #512 of the CIDR divided into /28s.
    // Note - the 2x public /20s take up the first 512 /28 blocks, which is why we start at block 512.
    // The two public NAT GW subnets take up block 512 and 513 respectively, so the private ranges start at 514.
    map_public_ip_on_launch = "false"
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
        Name = "LAN Subnet"
    }
}

output "private_subnets" {
    value = aws_subnet.sdwan-lab-private
    description = "Private Subnet Objects"
}
