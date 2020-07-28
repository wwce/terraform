#NGFW ALB

resource "aws_lb" "ngfw-alb" {
  name                       = "ngfw-alb"
  internal                   = false
  security_groups            = ["${aws_security_group.blue_team_open.id}"]
  subnets                    = ["${aws_subnet.blue_team_az1_untrust.id}", "${aws_subnet.blue_team_az2_untrust.id}"]
  enable_deletion_protection = false
  load_balancer_type         = "application"
  tags = {
    Name = "blue_team_ngfw"
  }
}

resource "aws_lb_target_group" "ngfw" {
  name        = "blue-team-ngfw"
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
  target_group_arn = "${aws_lb_target_group.ngfw.arn}"
  target_id        = "${aws_network_interface.blue_team_ngfw_untrust.private_ip}"
  port             = 80
}

resource "aws_lb_listener" "ngfw-alb" {
  load_balancer_arn = "${aws_lb.ngfw-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.ngfw.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = "${aws_lb_listener.ngfw-alb.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.ngfw.arn}"
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

#Native ALB

resource "aws_lb" "native-alb" {
  name                       = "native-alb"
  internal                   = false
  security_groups            = ["${aws_security_group.blue_team_open.id}"]
  subnets                    = ["${aws_subnet.blue_team_az1_untrust.id}", "${aws_subnet.blue_team_az2_untrust.id}"]
  enable_deletion_protection = false
  load_balancer_type         = "application"

  tags = {
    Name = "blue_team_native"
  }
}

resource "aws_lb_target_group" "blue_team_native" {
  name        = "blue-team-native"
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

resource "aws_lb_target_group_attachment" "server-native" {
  target_group_arn = "${aws_lb_target_group.blue_team_native.arn}"
  target_id        = "${aws_network_interface.blue_team_server.private_ip}"
  port             = 8080
}

resource "aws_lb_listener" "native-alb" {
  load_balancer_arn = "${aws_lb.native-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.blue_team_native.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "static2" {
  listener_arn = "${aws_lb_listener.native-alb.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.blue_team_native.arn}"
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
