resource "aws_instance" "reactapp-instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  subnet_id              = module.vpc.public_subnet_id[0]
  vpc_security_group_ids = [module.vpc.security_group_id]
  key_name               = aws_key_pair.reactapp.key_name
  user_data              = data.cloudinit_config.reactapp.rendered
  iam_instance_profile   = aws_iam_instance_profile.reactapp-role.name

  depends_on = [
    aws_ebs_volume.reactapp-data
  ]

  tags = {
    Name = "reactapp-vm"
  }
}

resource "aws_ebs_volume" "reactapp-data" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "reactapp-master"
  }
}

resource "aws_volume_attachment" "reactapp-data-attachment" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.reactapp-data.id
  instance_id  = aws_instance.reactapp-instance.id
  skip_destroy = true
}

resource "aws_key_pair" "reactapp" {
  key_name   = "reactapp"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC15ULI9Mh35KG4gIX0QJBcP9cFiA/6hZaB8KE9gRYbF7mv6YFelDo+mBZ3fK0ZxliNlXOfbK8kugupYr69Zfjl8CUDAN9ebrKarwQTWht/Yk+s40wS+xQh+SzlgU5MOepmo/3MxPi3GOujo7vpGDgH0dU6vte1K8VQrZQo4DFsGEdGyLHvn9Xxp4Vf65JFWw8Lg7s9gQOCDTh8PjLimfV/plEMwXbKnpqXXc5uKhw2KF4DFBKGxdmA2EcsxSVg2UBySvWSJgwBVXeBLxh8gOR7RqSH16h3SdfUfwTrHkwtAbDIyQq4M5+TURgTPpQTX8+POelk42fcJeXAZusQgxNzs6wS3tJwUVkf3zhLljoOFK0p5pOrlKX1QBL2gKeyZuRC/eQE0kgFRK/Z0yrngm5sLvKbx3/dVZhj1moXH7g0ArychJ0+7m1q/KftIFJaNK5QDsOxNDHKFGLSM87qBWTOfF8mAhUJZPuxnJCFfKgpkMh0/TmhdBkyOOpoFB1TUgE= lbena@LAPTOP-QB0DU4OG"
  lifecycle {
    ignore_changes = [public_key]
  }
}

resource "aws_iam_role" "reactapp-role" {
  name               = "reactapp-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "reactapp-role" {
  name = "reactapp-role"
  role = aws_iam_role.reactapp-role.name
}

resource "aws_iam_role_policy" "admin-policy" {
  name = "reactapp-admin-role-policy"
  role = aws_iam_role.reactapp-role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}