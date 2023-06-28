

resource "aws_launch_template" "ec2_launch_template" {
  for_each = var.instance_configs

  name          = "ec2-launch-template-${each.key}"
  image_id      = each.value.ami_id
  instance_type = each.value.instance_type

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 100
      volume_type = "gp2"
    }
  }

  vpc_security_group_ids = [each.value.security_group]
  key_name               = each.value.key_pair

  network_interfaces {
    device_index                = 0
    subnet_id                   = aws_subnet.private_subnet[each.key].id
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "EC2 Instance - ${each.key}"
    }
  }
}