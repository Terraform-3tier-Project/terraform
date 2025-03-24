resource "aws_launch_template" "this" {
  name_prefix   = "webserver-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.ec2_sg_ids

  user_data = base64encode(var.user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }

  iam_instance_profile {
    name = var.instance_profile_name
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix         = var.asg_name_prefix
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      instance_warmup        = 60
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
}
