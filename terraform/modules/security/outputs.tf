output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "front_sg_id" {
  value = aws_security_group.front.id
}

output "back_sg_id" {
  value = aws_security_group.back.id
}

output "mysql_sg_id" {
  value = aws_security_group.mysql.id
}