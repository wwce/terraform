resource "aws_instance" "ion" {
    count=var.ENV_COUNT

    ami = lookup(var.ION_AMI_MAP, var.AWS_REGION)
    instance_type = lookup(var.ION_MODEL_MAP, var.ION_MODEL)

    # the Public SSH key
    key_name = aws_key_pair.sdwan-lab-default-key-pair.id

    user_data = <<EOF
[General]
model = ${var.ION_MODEL}
${var.USERDATA_HOST1_NAME != "" ? "host1_name = ${var.USERDATA_HOST1_NAME}" : ""}
${var.USERDATA_HOST1_IP != "" ? "host1_ip = ${var.USERDATA_HOST1_IP}" : ""}
${var.USERDATA_HOST2_NAME != "" ? "host2_name = ${var.USERDATA_HOST2_NAME}" : ""}
${var.USERDATA_HOST2_IP != "" ? "host2_ip = ${var.USERDATA_HOST2_IP}" : ""}
${var.USERDATA_HOST3_NAME != "" ? "host3_name = ${var.USERDATA_HOST3_NAME}" : ""}
${var.USERDATA_HOST3_IP != "" ? "host3_ip = ${var.USERDATA_HOST3_IP}" : ""}

[License]
key = ${var.USERDATA_KEY}
secret = ${var.USERDATA_SECRET}

[Controller 1]
type = DHCP

[1]
role = PublicWAN
type = DHCP

[2]
role = PublicWAN
type = DHCP
EOF

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.ion-controller[count.index].id
    }

    network_interface {
        device_index = 1
        network_interface_id = aws_network_interface.ion-lan[count.index].id
    }

    network_interface {
        device_index = 2
        network_interface_id = aws_network_interface.ion-public1[count.index].id
    }

    tags = {
      "Name" = "sdwan-lab-${var.CUSTOMER_IDENTIFIER}-ion-${var.ENV_START + count.index}"
    }
}

resource "aws_instance" "tgen" {
    count=var.ENV_COUNT

    ami = lookup(var.TGEN_AMI_MAP, var.AWS_REGION)
    instance_type = var.TGEN_INSTANCE_TYPE

    # the Public SSH key
    key_name = aws_key_pair.sdwan-lab-default-key-pair.id

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.tgen-lan[count.index].id
    }

    tags = {
      "Name" = "sdwan-lab-${var.CUSTOMER_IDENTIFIER}-tgen-${var.ENV_START + count.index}"
    }
}

output "ion_instances" {
    value = aws_instance.ion
    description = "ION Instance objects"
}

