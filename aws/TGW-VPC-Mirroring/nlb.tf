resource "aws_lb" "mirror-lb" {
  name               = "mirror-lb-tf"
  internal           = true
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.vpc_mirror_pub_1.id}","${aws_subnet.vpc_mirror_pub_2.id}"]
  
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  tags = {
  }
}
resource "aws_lb_target_group" "mirror-target" {
  name     = "mirror-target"
  port     = 4789
  protocol = "UDP"
  vpc_id   = "${aws_vpc.vpc_security.id}"
  health_check {
      port = 80
      protocol = "HTTP"
  }
}
resource "aws_lb_listener" "mirror-listener" {
  load_balancer_arn = "${aws_lb.mirror-lb.arn}"
  port              = "4789"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.mirror-target.arn}"
  }
}
resource "aws_lb_target_group_attachment" "mirror1" {
  target_group_arn = "${aws_lb_target_group.mirror-target.arn}"
  target_id        = "${module.ngfw3.instanceid}"
}
resource "aws_lb_target_group_attachment" "mirror3" {
  target_group_arn = "${aws_lb_target_group.mirror-target.arn}"
  target_id        = "${module.ngfw4.instanceid}"
}