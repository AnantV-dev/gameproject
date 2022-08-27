output "DNS" {
  value = aws_instance.server.public_ip
}

output "aws_link" {
  value=format("Access the AWS hosted webapp from here: http://%s%s", aws_instance.server.public_dns, ":8080/gaming")
}

output "instance_ip_addr" {
  value = aws_instance.server.private_ip
}