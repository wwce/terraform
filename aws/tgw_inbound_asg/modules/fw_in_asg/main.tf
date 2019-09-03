resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "random_string" "randomstring" {
  length      = 6
  min_upper   = 4
  min_numeric = 2
  special     = false
}

resource "aws_iam_role" "FirewallBootstrapRole" {
  name = "${var.tag}-vmseries-${random_string.randomstring.result}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "FirewallBootstrapInstanceProfile" {
  name = "${var.tag}-FirewallInstanceProfile-${random_string.randomstring.result}"
  role = "${aws_iam_role.FirewallBootstrapRole.name}"
  path = "/"
}

resource "aws_iam_role_policy" "FirewallBootstrapRolePolicy" {
  name = "${var.tag}-FirewallRolePolicy-${random_string.randomstring.result}"
  role = "${aws_iam_role.FirewallBootstrapRole.id}"

  depends_on = [
    "null_resource.dependency_getter",
  ]

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.fw_bucket}"
    },
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.fw_bucket}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "LambdaExecutionRole" {
  name = "${var.tag}-LambdaExecutionRole-${random_string.randomstring.result}"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaExecutionRolePolicy" {
  name = "${var.tag}-LambdaExecutionRolePolicy-${random_string.randomstring.result}"
  role = "${aws_iam_role.LambdaExecutionRole.id}"

  depends_on = [
    "null_resource.dependency_getter",
  ]

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": "s3:ListBucket",
          "Resource": "arn:aws:s3:::${var.fw_bucket}"
        },
        {
          "Effect": "Allow",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::${var.fw_bucket}/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AllocateAddress",
                "ec2:AssociateAddress",
                "ec2:AssociateRouteTable",
                "ec2:AttachInternetGateway",
                "ec2:AttachNetworkInterface",
                "ec2:CreateNetworkInterface",
                "ec2:CreateTags",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteRouteTable",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteTags",
                "ec2:DescribeAddresses",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeInstances",
                "ec2:DescribeImages",
                "ec2:DescribeNatGateways",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeTags",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DetachInternetGateway",
                "ec2:DetachNetworkInterface",
                "ec2:DetachVolume",
                "ec2:DisassociateAddress",
                "ec2:DisassociateRouteTable",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:ModifySubnetAttribute",
                "ec2:MonitorInstances",
                "ec2:RebootInstances",
                "ec2:ReleaseAddress",
                "ec2:ReportInstanceStatus",
                "ec2:TerminateInstances",
                "ec2:DescribeIdFormat"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "events:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "lambda:AddPermission",
                "lambda:CreateEventSourceMapping",
                "lambda:CreateFunction",
                "lambda:DeleteEventSourceMapping",
                "lambda:DeleteFunction",
                "lambda:GetEventSourceMapping",
                "lambda:ListEventSourceMappings",
                "lambda:RemovePermission",
                "lambda:UpdateEventSourceMapping",
                "lambda:UpdateFunctionCode",
                "lambda:UpdateFunctionConfiguration",
                "lambda:GetFunction",
                "lambda:ListFunctions"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:SendMessage",
                "sqs:SetQueueAttributes",
                "sqs:PurgeQueue",
                "sqs:DeleteMessage"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:AttachLoadBalancerToSubnets",
                "elasticloadbalancing:ConfigureHealthCheck",
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
                "elasticloadbalancing:DescribeLoadBalancerPolicies",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DetachLoadBalancerFromSubnets",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:DescribeTargetGroups"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "iam:GetRole"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:DescribeStacks"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutDestination",
                "logs:PutDestinationPolicy",
                "logs:PutLogEvents",
                "logs:PutMetricFilter"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:*:*:*"
        }
    ]
}
EOF
}

resource "aws_lambda_function" "FwInit" {
  function_name = "${var.tag}-FwInit-${random_string.randomstring.result}"
  handler       = "fw_init.lambda_handler"
  role          = "${aws_iam_role.LambdaExecutionRole.arn}"
  s3_bucket     = "${var.lambda_bucket}"
  s3_key        = "${var.KeyMap["Key"]}"
  runtime       = "python2.7"
  timeout       = "300"

  vpc_config {
    subnet_ids         = ["${var.lambda_subnet_id}"]
    security_group_ids = ["${var.vpc_sg_id}"]
  }

  depends_on = [
    "null_resource.dependency_getter",
  ]
}

resource "aws_sqs_queue" "LambdaENIQueue" {
  name = "${var.tag}-LambdaENIQueue-${random_string.randomstring.result}"

  depends_on = [
    "aws_lambda_function.InitLambda",
  ]
}

resource "aws_sns_topic" "LambdaENISNSTopic" {
  name = "${var.tag}-LambdaENISNSTopic-${random_string.randomstring.result}"

  depends_on = [
    "aws_lambda_function.FwInit",
  ]
}

resource "aws_sns_topic_subscription" "LambdaENISNSTopicSubscription" {
  topic_arn = "${aws_sns_topic.LambdaENISNSTopic.arn}"
  endpoint  = "${aws_lambda_function.FwInit.arn}"
  protocol  = "lambda"

  depends_on = [
    "aws_lambda_function.FwInit",
  ]
}

resource "aws_lambda_permission" "LambdaENIPermission" {
  statement_id  = "ProvideLambdawithPermissionstoSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.FwInit.arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.LambdaENISNSTopic.arn}"

  depends_on = [
    "aws_lambda_function.FwInit",
    "aws_sns_topic.LambdaENISNSTopic",
  ]
}

resource "aws_sqs_queue" "NetworkLoadBalancerQueue" {
  name = "${var.tag}-NetworkLoadBalancerQueue-${random_string.randomstring.result}"
}

resource "aws_iam_role" "ASGNotifierRole" {
  name = "${var.tag}-ASGNotifierRole-${random_string.randomstring.result}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement": [{
    "Effect": "Allow",
    "Principal": {
        "Service": ["autoscaling.amazonaws.com"]
    },
    "Action": ["sts:AssumeRole"]
    }]
}
EOF
}

resource "aws_iam_role_policy" "ASGNotifierRolePolicy" {
  name = "${var.tag}-ASGNotifierRolePolicy-${random_string.randomstring.result}"
  role = "${aws_iam_role.ASGNotifierRole.id}"

  depends_on = [
    "aws_sns_topic.LambdaENISNSTopic",
  ]

  policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement": [{
    "Effect": "Allow",
    "Action": "sns:Publish",
    "Resource": "${aws_sns_topic.LambdaENISNSTopic.arn}"
    }]
}
EOF
}

resource "aws_lambda_function" "InitLambda" {
  function_name = "${var.tag}-InitLambda-${random_string.randomstring.result}"
  handler       = "init.lambda_handler"
  role          = "${aws_iam_role.LambdaExecutionRole.arn}"
  s3_bucket     = "${var.lambda_bucket}"
  s3_key        = "${var.KeyMap["Key"]}"
  runtime       = "python2.7"
  timeout       = "300"

  depends_on = [
    "aws_iam_role.LambdaExecutionRole",
    "null_resource.dependency_getter",
  ]
}

resource "aws_security_group" "PublicLoadBalancerSecurityGroup" {
  vpc_id      = "${var.vpc_id}"
  description = "Public ELB security group"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tag}-elb-sg"
  }
}

resource "aws_lb" "PublicLoadBalancer" {
  name               = "${var.tag}-vmseries-elb-${random_string.randomstring.result}"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${var.fw_subnet1_id}"]
  security_groups    = ["${aws_security_group.PublicLoadBalancerSecurityGroup.id}"]

  tags = {
    Environment = "${var.tag}-vmseries-elb"
  }
}

resource "aws_lb_target_group" "PublicLoadBalancerTargetGroup" {
  name = "${var.tag}-81-${random_string.randomstring.result}"

  depends_on = [
    "aws_lb.PublicLoadBalancer",
  ]

  health_check {
    enabled             = true
    interval            = 60
    unhealthy_threshold = 10
    protocol            = "HTTP"
    port                = 81
    path                = "/index.html"
    matcher             = "200"
  }

  port     = 81
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "PublicLoadBanlancerListener" {
  load_balancer_arn = "${aws_lb.PublicLoadBalancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.PublicLoadBalancerTargetGroup.arn}"
  }
}

resource "aws_security_group" "mgmt" {
  vpc_id      = "${var.vpc_id}"
  description = "Security Group assigned to VM-Series management ENI"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.fw_sg_source}"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tag}-mgmt-sg"
  }
}

resource "aws_security_group" "untrust" {
  vpc_id      = "${var.vpc_id}"
  description = "Security Group assigned to VM-Series untrust ENI"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tag}-untrust-sg"
  }
}

resource "aws_security_group" "trust" {
  vpc_id      = "${var.vpc_id}"
  description = "Security Group assigned to VM-Series trust ENI"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tag}-trust-sg"
  }
}

resource "aws_cloudformation_stack" "LambdaCustomResource" {
  name       = "${var.tag}-LambdaCustomResource"
  depends_on = ["aws_lambda_function.FwInit", "aws_lambda_function.InitLambda", "null_resource.dependency_getter"]

  parameters {
    InitLambdaArn                    = "${aws_lambda_function.InitLambda.arn}"
    StackName                        = "${var.tag}"
    Region                           = "${var.region}"
    VPCID                            = "${var.vpc_id}"
    MGMTSubnetAz1                    = "${join(",", var.fw_subnet0_id)}"
    UNTRUSTSubnetAz1                 = "${join(",", var.fw_subnet1_id)}"
    TRUSTSubnetAz1                   = "${join(",", var.fw_subnet2_id)}"
    MgmtSecurityGroup                = "${aws_security_group.mgmt.id}"
    UntrustSecurityGroup             = "${aws_security_group.untrust.id}"
    TrustSecurityGroup               = "${aws_security_group.trust.id}"
    VPCSecurityGroup                 = "${var.vpc_sg_id}"
    KeyName                          = "${var.fw_key_name}"
    ELBName                          = "${aws_lb.PublicLoadBalancer.id}"
    ELBTargetGroupName               = "${aws_lb_target_group.PublicLoadBalancerTargetGroup.name}"
    FWInstanceType                   = "${var.fw_vm_type}"
    SSHLocation                      = "${var.fw_sg_source}"
    MinInstancesASG                  = "${var.fw_min_instances}"
    MaximumInstancesASG              = "${var.fw_max_instances}"
    ScaleUpThreshold                 = "${var.fw_scale_threshold_up}"
    ScaleDownThreshold               = "${var.fw_scale_threshold_down}"
    ScalingParameter                 = "${var.fw_scale_parameter}"
    ScalingPeriod                    = "${var.fw_scale_period}"
    PanFwAmiId                       = "${var.fw_ami}"
    LambdaENISNSTopic                = "${aws_sns_topic.LambdaENISNSTopic.id}"
    FirewallBootstrapInstanceProfile = "${aws_iam_instance_profile.FirewallBootstrapInstanceProfile.id}"
    LambdaExecutionRole              = "${aws_iam_role.LambdaExecutionRole.id}"
    ASGNotifierRole                  = "${aws_iam_role.ASGNotifierRole.arn}"
    ASGNotifierRolePolicy            = "${aws_iam_role_policy.ASGNotifierRolePolicy.id}"
    BootstrapS3Bucket                = "${var.fw_bucket}"
    LambdaS3Bucket                   = "${var.lambda_bucket}"
    PanS3KeyTpl                      = "${var.KeyMap["Key"]}"
    KeyPANWFirewall                  = "${var.api_key_firewall}"
    KeyPANWPanorama                  = "${var.api_key_panorama}"
    NATGWSubnetAz1                   = "${join(",", var.natgw_subnet_id)}"
    LambdaSubnetAz1                  = "${join(",", var.lambda_subnet_id)}"
    FwInit                           = "${aws_lambda_function.FwInit.id}"
    InitLambda                       = "${aws_lambda_function.InitLambda.id}"
    KeyDeLicense                     = "${var.api_key_delicense}"
    LambdaENIQueue                   = "${aws_sqs_queue.LambdaENIQueue.id}"
    Debug                            = "${var.enable_debug}"
    NetworkLoadBalancerQueue         = "${aws_sqs_queue.NetworkLoadBalancerQueue.id}"
  }

  template_body = <<STACK
{
    "Parameters" : {
        "InitLambdaArn": {
            "Type": "String",
            "Description": "ARN of the Init Lambda function"
        },
        "StackName": {
            "Type": "String",
            "Description": "Name of the Stack"
        },
        "Region": {
            "Type": "String",
            "Description": "The Region that the infrastructure is being deployed into"
        },
        "VPCID": {
            "Type": "String",
            "Description": "VPC ID"
        },
        "MGMTSubnetAz1" : {
            "Type" : "CommaDelimitedList",
            "Description": "Enter Subnet ID for the mgmt interface for AZ1"
        },
        "UNTRUSTSubnetAz1" : {
            "Type" : "CommaDelimitedList",
            "Description": "Enter Subnet ID for the untrust interface for AZ1"
        },
        "TRUSTSubnetAz1" : {
            "Type" : "CommaDelimitedList",
            "Description": "Enter Subnet ID for the trust interface for AZ1"
        },      
        "MgmtSecurityGroup": {
            "Type": "String",
            "Description": "Mgmt Security Group"
        },
        "UntrustSecurityGroup": {
            "Type": "String",
            "Description": "Untrust Security Group"
        },
        "TrustSecurityGroup": {
            "Type": "String",
            "Description": "Trust Security Group"
        },
        "VPCSecurityGroup": {
            "Type": "String",
            "Description": "VPC Security Group"
        },
        "KeyName": {
            "Type": "String",
            "Description": "Name of an existing Key in AWS"
        },
        "ELBName": {
            "Type": "String",
            "Description": "Name of the ELB"
        },
        "ELBTargetGroupName": {
            "Type": "String",
            "Description": "ELB Target Group Name"
        },
        "FWInstanceType": {
            "Type": "String",
            "Description": "FW Instance Type"
        },
        "SSHLocation": {
            "Type": "String",
            "Description": "The CIDR from where ssh sessions will originate"
        },
        "MinInstancesASG": {
            "Type": "String",
            "Description": "Minimum # of desired FW instances"
        },
        "MaximumInstancesASG": {
            "Type": "String",
            "Description": "Max # of instances in the ASG"
        },
        "ScaleUpThreshold": {
            "Type": "String",
            "Description": "The threshold which triggers a scale up event"
        },
        "ScaleDownThreshold": {
            "Type": "String",
            "Description": "The threshold which triggers a scale down event"
        },
        "ScalingParameter": {
            "Type": "String",
            "Description": "Parameter which determines the scaling"
        },
        "ScalingPeriod": {
            "Type": "String",
            "Description": "The duration of the scaling"
        },
        "PanFwAmiId": {
            "Type": "String",
            "Description": "AMI id of the PANW FW for the chosen region"
        },
        "LambdaENISNSTopic": {
            "Type": "String",
            "Description": "SNS topic that receives ASG notifications"
        },
        "FirewallBootstrapInstanceProfile": {
            "Type": "String",
            "Description": "Just a simple message"
        },
        "LambdaExecutionRole": {
            "Type": "String",
            "Description": "Just a simple message"
        },
        "ASGNotifierRole": {
            "Type": "String",
            "Description": "Just a simple message"
        },
        "ASGNotifierRolePolicy": {
            "Type": "String",
            "Description": "Just a simple message"
        },
        "BootstrapS3Bucket": {
            "Type": "String",
            "Description": "S3 bucket for firewall bootstrap"
        },
        "LambdaS3Bucket": {
            "Type": "String",
            "Description": "S3 bucket for firewall bootstrap"
        },
        "PanS3KeyTpl": {
            "Type": "String",
            "Description": "Version Associated with PANW Lambda"
        },
        "KeyPANWFirewall": {
            "Type": "String",
            "Description": "Just a simple message"
        },
        "KeyPANWPanorama": {
            "Type": "String",
            "Description": "Just a simple message"
        },
        "NATGWSubnetAz1": {
            "Description": "Subnet IDs of AWS NAT Gateway in AZ1 ",
            "Type" : "CommaDelimitedList"
        },
        "LambdaSubnetAz1": {
            "Description": "Subnet IDs of Lambda Function interface in AZ1",
            "Type" : "CommaDelimitedList"
        },
        "FwInit": {
            "Type": "String",
            "Description": "ARN of the Init FW function"
        },
        "InitLambda": {
            "Type": "String",
            "Description": "ARN of the Init Lambda function"
        },
        "KeyDeLicense": {
            "Type": "String",
            "Description": "The key to be used to delicense the Firewall"
        },
        "LambdaENIQueue": {
            "Type": "String",
            "Description": "Just a simple message"
        },
        "Debug": {
            "Type": "String",
            "Default": "No",
            "AllowedValues": [
                "Yes",
                "No"
            ]
        },
        "NetworkLoadBalancerQueue": {
            "Type": "String",
            "Description": "NLB Queue"
        }
    },
    "Resources" : {
    "LambdaCustomResource": {
        "Type": "AWS::CloudFormation::CustomResource",
        "Version" : "1.0",
         "Properties" : {
            "ServiceToken": {"Ref": "InitLambdaArn"},
            "StackName": {"Ref": "StackName"},
            "Region": {"Ref": "Region"},
            "VpcId": {"Ref": "VPCID"},
            "SubnetIDMgmt": { "Ref" : "MGMTSubnetAz1" },
            "SubnetIDUntrust": { "Ref" : "UNTRUSTSubnetAz1" },
            "SubnetIDTrust": { "Ref" : "TRUSTSubnetAz1" },
            "MgmtSecurityGroup": {"Ref": "MgmtSecurityGroup"},
            "UntrustSecurityGroup": {"Ref": "UntrustSecurityGroup"},
            "TrustSecurityGroup": {"Ref": "TrustSecurityGroup"},
            "VPCSecurityGroup": {"Ref": "VPCSecurityGroup"},
	          "KeyName" : {"Ref": "KeyName"},
	          "ELBName" : {"Ref": "ELBName"},
	          "ELBTargetGroupName"  : { "Ref": "ELBTargetGroupName"},
	          "FWInstanceType" : {"Ref": "FWInstanceType"},
	          "SSHLocation" : {"Ref": "SSHLocation"},
            "MinInstancesASG": {"Ref": "MinInstancesASG"},	          
	          "MaximumInstancesASG" : {"Ref": "MaximumInstancesASG"},
	          "ScaleUpThreshold" : {"Ref": "ScaleUpThreshold"},
	          "ScaleDownThreshold" : {"Ref": "ScaleDownThreshold"},
	          "ScalingParameter" : {"Ref": "ScalingParameter"},
	          "ScalingPeriod" : {"Ref": "ScalingPeriod"},
	          "ImageID" : { "Ref": "PanFwAmiId" },
            "LambdaENISNSTopic": {"Ref": "LambdaENISNSTopic"},
            "FirewallBootstrapRole": {"Ref": "FirewallBootstrapInstanceProfile"},
            "LambdaExecutionRole": {"Ref": "LambdaExecutionRole"},
            "ASGNotifierRole": {"Ref": "ASGNotifierRole"},
            "ASGNotifierRolePolicy": {"Ref": "ASGNotifierRolePolicy"},
	          "BootstrapS3Bucket" : { "Ref" : "BootstrapS3Bucket" },
	          "LambdaS3Bucket" : { "Ref" : "LambdaS3Bucket" },
	          "PanS3KeyTpl" : { "Ref" : "PanS3KeyTpl" },
	          "KeyPANWFirewall" : { "Ref" : "KeyPANWFirewall" },
	          "KeyPANWPanorama" : { "Ref" : "KeyPANWPanorama" },
            "SubnetIDNATGW": { "Ref" : "NATGWSubnetAz1" },
            "SubnetIDLambda": { "Ref" : "LambdaSubnetAz1" }, 
            "FwInit": {"Ref": "FwInit"},
            "InitLambda": {"Ref": "InitLambda"},
            "KeyDeLicense": { "Ref": "KeyDeLicense" },
            "LambdaENIQueue" : { "Ref": "LambdaENIQueue" },
            "Debug": {"Ref": "Debug" },
            "NetworkLoadBalancerQueue" : { "Ref": "NetworkLoadBalancerQueue" }
       }
    }
  }
}
STACK
}
