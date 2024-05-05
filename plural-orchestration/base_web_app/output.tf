###############################################################################
# OUTPUT #
###############################################################################

output "aws_alb_public_dns" {
  value       = "http://${aws_lb.nginx.dns_name}"
  description = "Public DNS for the application load balancer"
}
output "aws_elb_service_account_root_arn" {
  value       = data.aws_elb_service_account.root.arn
  description = "ELB Service account root arn"
}