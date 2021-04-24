provider "aws" {
#  access_key = "${var.aws_access_key}"
#  secret_key = "${var.aws_secret_key}"
  region = var.aws_region
}

resource "random_pet" "blue_team" {
}

