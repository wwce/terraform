#External ALB

resource "aws_lb" "panos-alb" {
  name                       = "panos-alb"
  internal                   = false
  security_groups            = ["${aws_security_group.sgWideOpen.id}"]
  subnets                    = ["${aws_subnet.AZ1-UNTRUST.id}", "${aws_subnet.AZ2-UNTRUST.id}"]
  enable_deletion_protection = false
  load_balancer_type         = "application"
}

resource "aws_lb_target_group" "fw-tg" {
  name        = "fw-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.main.id}"
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/login"
    port                = 80
    interval            = 30
  }
}

resource "aws_lb_target_group_attachment" "fw1" {
  target_group_arn = "${aws_lb_target_group.fw-tg.arn}"
  target_id        = "${aws_network_interface.FW1-UNTRUST.private_ips[0]}"
  port             = 80
}

resource "aws_lb_listener" "panos-alb" {
  load_balancer_arn = "${aws_lb.panos-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.fw-tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = "${aws_lb_listener.panos-alb.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.fw-tg.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}

#Native ALB

resource "aws_lb" "native-alb" {
  name                       = "native-alb"
  internal                   = false
  security_groups            = ["${aws_security_group.sgWideOpen.id}"]
  subnets                    = ["${aws_subnet.AZ1-UNTRUST.id}", "${aws_subnet.AZ2-UNTRUST.id}"]
  enable_deletion_protection = false
  load_balancer_type         = "application"
}

resource "aws_lb_target_group" "native-tg" {
  name        = "native-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.main.id}"
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/login"
    port                = 8080
    interval            = 30
  }
}

resource "aws_lb_target_group_attachment" "web1a" {
  target_group_arn = "${aws_lb_target_group.native-tg.arn}"
  target_id        = "${aws_network_interface.web1-int.private_ips[0]}"
  port             = 8080
}

resource "aws_lb_listener" "native-alb" {
  load_balancer_arn = "${aws_lb.native-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.native-tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "static2" {
  listener_arn = "${aws_lb_listener.native-alb.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.native-tg.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}

#Internal NLB

resource "aws_lb" "int-nlb" {
  name                             = "INT-NLB"
  load_balancer_type               = "network"
  internal                         = true
  subnets                          = ["${aws_subnet.AZ1-TRUST.id}", "${aws_subnet.AZ2-TRUST.id}"]
  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false
}

resource "aws_lb_target_group" "web-tg" {
  name        = "web-tg"
  port        = 8080
  protocol    = "TCP"
  vpc_id      = "${aws_vpc.main.id}"
  target_type = "ip"
}

resource "aws_lb_target_group_attachment" "web1" {
  target_group_arn = "${aws_lb_target_group.web-tg.arn}"
  target_id        = "${aws_network_interface.web1-int.private_ips[0]}"
  port             = 8080
}

resource "aws_lb_listener" "int-nlb" {
  load_balancer_arn = "${aws_lb.int-nlb.arn}"
  port              = "8080"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.web-tg.arn}"
    type             = "forward"
  }
}
