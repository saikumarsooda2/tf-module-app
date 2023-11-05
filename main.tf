#
#resource "aws_iam_policy" "policy" {
#  name        = "${var.component}-${var.env}-ssm-pm-policy"
#  path        = "/"
#  description = "${var.component}-${var.env}-ssm-pm-policy"
#
#  policy = jsonencode({
#    "Version": "2012-10-17",
#    "Statement": [
#      {
#        "Sid": "VisualEditor0",
#        "Effect": "Allow",
#        "Action": [
#          "ssm:GetParameterHistory",
#          "ssm:GetParametersByPath",
#          "ssm:GetParameters",
#          "ssm:GetParameter"
#        ],
#        "Resource": "arn:aws:ssm:us-east-1:968066185838:parameter/roboshop.dev.frontend.*"
#      }
#    ]
#  }
#
#  )
#}
## aws instance role
#
#resource "aws_iam_role" "role" {
#  name = "${var.component}-${var.env}-ec2-role"
#
#  assume_role_policy = jsonencode({
#    Version   = "2012-10-17"
#    Statement = [
#      {
#        Action    = "sts:AssumeRole"
#        Effect    = "Allow"
#        Sid       = ""
#        Principal = {
#          Service = "ec2.amazonaws.com"
#        }
#      }
#    ]
#  })
#
#}
#resource "aws_iam_instance_profile" "instance_profile" {
#  name = "${var.component}-${var.env}-instance_profile"
#  role = aws_iam_role.role.name
#}
#
## sg
#resource "aws_security_group" "sg" {
#  name        = "${var.component}-${var.env}"
#  description = "Allow TLS inbound traffic"
#
#  ingress {
#    description      = "TLS from VPC"
#    from_port        = 0
#    to_port          = 0
#    protocol         = "-1"
#    cidr_blocks      = ["0.0.0.0/0"]
#
#  }
#
#  egress {
#    from_port        = 0
#    to_port          = 0
#    protocol         = "-1"
#    cidr_blocks      = ["0.0.0.0/0"]
#
#  }
#
#  tags = {
#    Name = "${var.component}-${var.env}"
#  }
#}
#
## aws instances ec2
#
#resource "aws_instance" "instance" {
#  ami                    = data.aws_ami.ami.id
#  instance_type          = "t3.micro"
#  vpc_security_group_ids = ["sg-06f9944ca8edc98f7"]
#  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
#  tags ={
#    Name = "${var.component}-${var.env}"
#  }
#}
#
## DNS records
#
#resource "aws_route53_record" "dns" {
#  zone_id = "Z026249313NGT4ABIR3B9"
#  name    = "${var.component}-${var.env}"
#  type    = "A"
#  ttl     = 300
#  records = [aws_instance.instance.private_ip]
#}
#
#resource "null_resource" "ansible" {
#
#  provisioner "remote-exec" {
#
#    connection {
#      type     = "ssh"
#      user     = "centos"
#      password = "DevOps321"
#      host     = aws_instance.instance.public_ip
#    }
#
#    inline = [
#      "sudo labauto ansible",
#      "ansible-pull -i localhost, -U https://github.com/saikumarsooda2/roboshop-ansible mainroboshop.yml -e env=dev -e role_name=${var.component}"
#    ]
#  }
#}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami                    = data.aws_ami.ami.id
  name = "jenkins"
  instance_type          = var.type
  key_name               = "user1"
  vpc_security_group_ids = var.vpc_id
  subnet_id              = var.subnet_id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}






























