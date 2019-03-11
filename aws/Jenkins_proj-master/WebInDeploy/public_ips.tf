resource "aws_eip" "FW1-PUB" {
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.gw"]
}

resource "aws_eip" "FW1-MGT" {
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.gw"]
}
#resource "aws_eip" "webserver" {
#  vpc   = true
#  depends_on = ["aws_vpc.main", "aws_internet_gateway.gw"]
#}
resource "aws_eip" "NAT_GW" {
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.gw"]
}