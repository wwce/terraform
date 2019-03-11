aws_region = "Place Region Here"

ServerKeyName = "Place AWs Keypair Here"

bootstrap_s3bucket = "Place S3 Bucket Name Here"

aws_access_key = "Place AWS API Access Key Here"

aws_secret_key = "Place AWS API Secret Key Here"

waf_prefix = "managed"

blacklisted_ips = [
  {
    value = "172.16.0.0/16"

    type = "IPV4"
  },
  {
    value = "192.168.0.0/16"

    type = "IPV4"
  },
  {
    value = "169.254.0.0/16"

    type = "IPV4"
  },
  {
    value = "127.0.0.1/32"

    type = "IPV4"
  },
  {
    value = "10.0.0.0/8"

    type = "IPV4"
  },
]

admin_remote_ipset = [
  {
    value = "127.0.0.1/32"

    type = "IPV4"
  },
]

alb_arn = "aws_lb.panos-alb.arn"
