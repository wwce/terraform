resource "aws_eip" "kali" {
  vpc        = true
  depends_on = ["aws_vpc.kali", "aws_internet_gateway.kaligw"]
}
