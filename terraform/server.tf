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
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]//Amazon Linux ubuntu
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

 resource "aws_instance" "server" {
   ami           = "ami-05fa00d4c63e32376" // can use data.aws_ami.ubuntu.id also but here i will use Amazon Linux 2
   key_name	= aws_key_pair.mykey1112.key_name
   iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
   instance_type = "t3.micro"
   subnet_id     = "${aws_subnet.public_subnet1.id}"
   associate_public_ip_address = true
   vpc_security_group_ids = [aws_security_group.ec2.id]
   user_data = data.template_file.asg_init.rendered

   tags = {
     Name = "Nginx-webserver"
   }
 } 

resource "aws_security_group" "ec2" {
  name = "ec2-security-group"

  description = "EC2 security group"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
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

data "template_file" "asg_init" {
  template = file("${path.module}/userdata.tpl")
}