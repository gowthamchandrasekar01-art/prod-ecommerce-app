resource "aws_launch_template" "app" {
  name = "prod-ecommerce-app-lt"

  image_id      = "ami-035827357e3c7e810"
  instance_type = "t3.micro"

  iam_instance_profile {
    arn = "arn:aws:iam::809311528378:instance-profile/prod-ecommerce-ec2-role"
  }
  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  user_data = base64encode(file("${path.module}/user_data.sh"))

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      iops                  = 3000
      throughput            = 125
      encrypted             = true
      kms_key_id            = "alias/aws/ebs"
      delete_on_termination = true
      snapshot_id           = "snap-0e060513bce7d40d7"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "prod-ecommerce-app-server"
      Environment = "Production"
    }
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}
