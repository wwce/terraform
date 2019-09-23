resource "aws_eip" "CONSOLE-MGT" {
  vpc        = true
  depends_on = ["aws_vpc.console", "aws_internet_gateway.consoleigw"]
}
