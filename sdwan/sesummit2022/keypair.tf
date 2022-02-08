resource "aws_key_pair" "sdwan-lab-default-key-pair" {
    key_name = "sdwan-lab-${var.CUSTOMER_IDENTIFIER}-default-key-pair"
    public_key = file(pathexpand(var.PUBLIC_KEY_PATH))
}