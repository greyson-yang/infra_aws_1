output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the Application Load Balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.example.name
  description = "The name of the Auto Scalling Group"
}

output "alb_sg_id" {
  value       = aws_security_group.alb.id
  description = "The ID of the Security Group attached to the load balancer"
}

output "instance_sg_id" {
  value       = aws_security_group.instance.id
  description = "The ID of the Security Group attached to the EC2 Instances"
}
