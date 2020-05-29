output "sqs_id" {
  value = "${aws_sqs_queue.NetworkLoadBalancerQueue.id}"
}

output "lb_dns_name" {
  value = "${aws_lb.PublicLoadBalancer.dns_name}"
}