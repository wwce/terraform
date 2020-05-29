resource "aws_eip" "panorama-mgt" {
  vpc   = true
  depends_on = ["aws_vpc.SDWAN", "aws_internet_gateway.SDWAN-IGW"]
}

resource "aws_eip" "hub-fw-mgt" {
  vpc   = true
  depends_on = ["aws_vpc.SDWAN", "aws_internet_gateway.SDWAN-IGW"]
}

resource "aws_eip" "branch25-fw-mgt" {
  vpc   = true
  depends_on = ["aws_vpc.SDWAN", "aws_internet_gateway.SDWAN-IGW"]
}

resource "aws_eip" "branch50-fw-mgt" {
  vpc   = true
  depends_on = ["aws_vpc.SDWAN", "aws_internet_gateway.SDWAN-IGW"]
}