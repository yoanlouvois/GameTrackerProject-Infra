output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_arn" {
  value = aws_lb.main.arn
}

output "front_target_group_arn" {
  value = aws_lb_target_group.front.arn
}

output "back_target_group_arn" {
  value = aws_lb_target_group.back.arn
}