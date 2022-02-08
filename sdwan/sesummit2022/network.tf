resource "aws_internet_gateway" "prod-igw" {
    vpc_id = aws_vpc.sdwan-lab-vpc.id
    tags = {
        Name = "sdwan-lab-${var.CUSTOMER_IDENTIFIER}-vpc-igw"
    }
}

// START PUBLIC1 NAT gateway shared EIP

resource "aws_route_table" "sdwan-lab-routetable-public1" {
    vpc_id = aws_vpc.sdwan-lab-vpc.id

    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prod-igw.id
    }

    tags = {
        Name = "sdwan-lab-${var.CUSTOMER_IDENTIFIER}-routetable-public1"
    }
}

resource "aws_route_table" "sdwan-lab-routetable-mgmt" {
    vpc_id = aws_vpc.sdwan-lab-vpc.id

    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prod-igw.id
    }

    tags = {
        Name = "sdwan-lab-${var.CUSTOMER_IDENTIFIER}-routetable-mgmt"
    }
}

resource "aws_route_table_association" "sdwan-lab-public-subnet1"{
    subnet_id = aws_subnet.sdwan-lab-public1.id
    route_table_id = aws_route_table.sdwan-lab-routetable-public1.id
}

resource "aws_route_table_association" "sdwan-lab-public-mgmt"{
    subnet_id = aws_subnet.sdwan-lab-mgmt.id
    route_table_id = aws_route_table.sdwan-lab-routetable-mgmt.id
}

resource "aws_route_table" "sdwan-lab-routetable-lan" {
    count = var.ENV_COUNT
    vpc_id = aws_vpc.sdwan-lab-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        network_interface_id = aws_network_interface.ion-lan[count.index].id
    }

    tags = {
        Name = "sdwan-lab-${var.CUSTOMER_IDENTIFIER}-routetable-lan"
    }
}

resource "aws_route_table_association" "sdwan-lab-lan-subnet"{
    count = var.ENV_COUNT
    subnet_id = aws_subnet.sdwan-lab-private[count.index].id
    route_table_id = aws_route_table.sdwan-lab-routetable-lan[count.index].id
}

resource "aws_security_group" "ion-pub-vpn-ssh" {
    vpc_id = aws_vpc.sdwan-lab-vpc.id

    name = "ion-pub-vpn-ssh"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh !
        // Do not do it in the production.
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 4500
        to_port = 4501
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 500
        to_port = 500
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.CUSTOMER_IDENTIFIER}-ion-pub-vpn-ssh"
    }
}

resource "aws_security_group" "ion-internal-any-any" {
    vpc_id = aws_vpc.sdwan-lab-vpc.id

    name = "ion-internal-any-any"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.CUSTOMER_IDENTIFIER}-ion-internal-any-any"
    }
}