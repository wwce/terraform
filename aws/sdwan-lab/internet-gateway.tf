resource "aws_internet_gateway" "SDWAN-IGW" {
  vpc_id = "${aws_vpc.SDWAN.id}"

  tags {
    Name = "SDWAN-IGW"
  }
}