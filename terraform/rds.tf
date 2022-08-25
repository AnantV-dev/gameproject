resource "aws_db_instance" "db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "hello"
  username             = "hello"
  password             = "hellohellohello"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.private.name
  vpc_security_group_ids = [aws_security_group._.id]
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "private" {
  name       = "main"
  subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  tags = {
    Name = "My DB subnet group"
  }
}


 resource "aws_security_group" "_" {
  name = "rds-security-group"

  description = "RDS Instance Security Group"
  vpc_id      = "${aws_vpc.vpc.id}"

  # Only MySQL in
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }
}

output "rds_endpoint_addr" {
  value = aws_db_instance.db.endpoint
}