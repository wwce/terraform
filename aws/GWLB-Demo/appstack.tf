module "app1" {
  source = "./app_stack/"
  name = "app1"
  access_key = var.access_key 
  secret_key = var.secret_key
  region = var.region
  availability_zone = var.app_stack1_availability_zone
  vpc_cidr =  var.app1_vpc_cidr
  gwlbe_service_id = jsondecode(data.local_file.gwlb.content).agwe_service_id
  gwlbe_service_name = jsondecode(data.local_file.gwlb.content).agwe_service_name
  tgw_id = aws_ec2_transit_gateway.panw-tgw.id
  tgw_sec_attach_id = aws_ec2_transit_gateway_vpc_attachment.as.id
  tgw_sec_route_table_id =aws_ec2_transit_gateway_route_table.tgw-main-sec-rt.id
  sec_gwlbe_ob_route_table_id = aws_route_table.agwe-rt[*].id
  sec_gwlbe_ew_route_table_id =aws_route_table.agwe-ew-rt[*].id
  natgw_route_table_id = aws_route_table.natgw-rt[*].id
  sec_gwlbe_ob_id = jsondecode(data.local_file.gwlb.content).agwe_id
  sec_gwlbe_ew_id = jsondecode(data.local_file.gwlb.content).agwe_ew_id
  sec_tgwa_route_table_id = aws_route_table.tgwa-rt[*].id
  public_key = var.public_key
  instance_type = "t2.micro"
  prefix = "PANW"
  app_mgmt_sg_list = []
  handoff_state_filename = "handoff_state_app1.json"
  python_script = "gwlbeapp1.py"
}

module "app2" {
  source = "./app_stack/"
  name = "app2"
  access_key = var.access_key 
  secret_key = var.secret_key
  region = var.region
  availability_zone = var.app_stack2_availability_zone
  vpc_cidr =  var.app2_vpc_cidr
  gwlbe_service_id = jsondecode(data.local_file.gwlb.content).agwe_service_id
  gwlbe_service_name = jsondecode(data.local_file.gwlb.content).agwe_service_name
  tgw_id = aws_ec2_transit_gateway.panw-tgw.id
  tgw_sec_attach_id = aws_ec2_transit_gateway_vpc_attachment.as.id
  tgw_sec_route_table_id =aws_ec2_transit_gateway_route_table.tgw-main-sec-rt.id
  sec_gwlbe_ob_route_table_id = aws_route_table.agwe-rt[*].id
  sec_gwlbe_ew_route_table_id =aws_route_table.agwe-ew-rt[*].id
  natgw_route_table_id = aws_route_table.natgw-rt[*].id
  sec_gwlbe_ob_id = jsondecode(data.local_file.gwlb.content).agwe_id
  sec_gwlbe_ew_id = jsondecode(data.local_file.gwlb.content).agwe_ew_id
  sec_tgwa_route_table_id = aws_route_table.tgwa-rt[*].id
  public_key = var.public_key
  instance_type = "t2.micro"
  prefix = "PANW"
  app_mgmt_sg_list = []
  handoff_state_filename = "handoff_state_app2.json"
  python_script = "gwlbeapp2.py"
}

