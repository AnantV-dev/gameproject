resource "tls_private_key" "my_key" {
  algorithm   = "RSA"
}

resource "aws_key_pair" "mykey1112" {
  key_name    = "mykey1112"
  public_key = tls_private_key.my_key.public_key_openssh
  }

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

 resource "aws_instance" "server" {
   ami           = data.aws_ami.ubuntu.id
   key_name	= aws_key_pair.mykey1112.key_name
   instance_type = "t3.micro"
   user_data=<<-EOF
   #!/bin/bash
   sudo amazon-linux-extras install tomcat8.5 -y
   sudo systemctl enable tomcat
   sudo systemctl start tomcat
   sudo cp /tmp/gaming.war /usr/share/tomcat/webapps/gaming.war
   EOF

   subnet_id     = "${aws_subnet.public_subnet1.id}"
   associate_public_ip_address = true
   vpc_security_group_ids = [aws_security_group.ec2.id]

   tags = {
     Name = "Nginx-webserver"
   }
 } 

resource "aws_security_group" "ec2" {
  name = "ec2-security-group"

  description = "EC2 security group"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "copy_file" {
  triggers = {
    public_ip = aws_instance.server.public_ip
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.my_key.private_key_pem
    host     = aws_instance.server.public_ip
  }

  provisioner "file" {
    source      = "../target/gaming.war"
    destination = "/tmp/gaming.war"
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = tls_private_key.my_key.private_key_pem
      host     = aws_instance.server.public_ip
      }
    }
  
    depends_on = [ aws_instance.server ]
}

output "DNS" {
  value = aws_instance.server.public_ip
}

output "aws_link" {
  value=format("Access the AWS hosted webapp from here: http://%s%s", aws_instance.server.public_dns, ":8080/gaming")
}

output "instance_ip_addr" {
  value = aws_instance.server.private_ip
}