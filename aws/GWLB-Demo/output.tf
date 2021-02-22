
output "deployment_id" {
  value = random_id.deployment_id.hex
}

output "firewall_ip" {
  value = aws_eip.fw-mgmt-eip[*].public_ip
}

output "sec_gwlbe_ob_route_table_id" {
  value = aws_route_table.agwe-rt[*].id
}

output "sec_gwlbe_ew_route_table_id" {value = aws_route_table.agwe-ew-rt[*].id
}

output "natgw_route_table_id" {
  value = aws_route_table.natgw-rt[*].id
}

output "sec_tgwa_route_table_id" {
  value = aws_route_table.tgwa-rt[*].id
}

output "tgw_id" {
  value = aws_ec2_transit_gateway.panw-tgw.id
}

output "tgw_sec_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.tgw-main-sec-rt.id
}

output "tgw_sec_attach_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.as.id
}

output "sec_gwlbe_ob_id" {
  value = jsondecode(data.local_file.gwlb.content).agwe_id
}

output "sec_gwlbe_ew_id" {
  value = jsondecode(data.local_file.gwlb.content).agwe_ew_id
}

output "gwlb_arn" {
  value = jsondecode(data.local_file.gwlb.content).agw_arn
}

output "gwlb_listener_arn" {
  value = jsondecode(data.local_file.gwlb.content).agw_listener_arn
}

output "gwlb_tg_arn" {
  value = jsondecode(data.local_file.gwlb.content).agw_tg_arn
}

output "gwlbe_service_name" {
  value = jsondecode(data.local_file.gwlb.content).agwe_service_name
}

output "gwlbe_service_id" {
  value = jsondecode(data.local_file.gwlb.content).agwe_service_id
}

output "app2_deployment_id" {
  value = module.app2.deployment_id
}

output "app2_fqdn" {
  value = module.app2.app_fqdn
}

output "app2_mgmt_ip" {
  value = module.app2.app_mgmt_ip
}

output "app2_gwlbe_id" {
  value = module.app2.app_gwlbe_id
}

output "app1_deployment_id" {
  value = module.app1.deployment_id
}

output "app1_fqdn" {
  value = module.app1.app_fqdn
}

output "app1_mgmt_ip" {
  value = module.app1.app_mgmt_ip
}

output "app1_gwlbe_id" {
  value = module.app1.app_gwlbe_id
}
