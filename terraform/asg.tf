resource "aws_autoscaling_group" "webserver" {
  name     = "nginx-asg"
  max_size = 2
  min_size = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity = 2
  force_delete     = true
#    placement_group           = aws_placement_group.test.id
  launch_configuration = aws_launch_configuration.webserver-launch-config.name
  vpc_zone_identifier  = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

  tag {
    key                 = "Name"
    value               = "nginx-webserver-asg"
    propagate_at_launch = true
  }
   lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancers, target_group_arns]

  }
  depends_on = [aws_instance.server]
}

resource "aws_autoscaling_attachment" "niginx-alb" {
  autoscaling_group_name = aws_autoscaling_group.webserver.id
  lb_target_group_arn   =  aws_lb_target_group.nginx-alb.arn
}

resource "aws_launch_configuration" "webserver-launch-config" {
  name          = "web_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install nginx -y
  sudo sevice nginx start
  EOF
  lifecycle {
  create_before_destroy = true
  }

}