#############################################################################################################
# DATA
############################################################################################################

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx1_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.example_instance_profile.name
  depends_on             = [aws_iam_policy.s3_access_policy]

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/index.html /home/ec2-user/index.html
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/test-image.png /home/ec2-user/test-image.png
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/test-image.png /usr/share/nginx/html/test-image.png
EOF

  tags = local.common_tags
}

resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx_alb_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.example_instance_profile.name
  depends_on             = [aws_iam_policy.s3_access_policy]

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Buia tchaca Team Server 02 !</title></head><body>Uh la la!</body></html>'
EOF

  tags = local.common_tags
}

# aws_iam_role
resource "aws_iam_role" "allow_nginx" {
  name = "allow-nginx"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "ec2.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })

  tags = local.common_tags
}

# aws_iam_role_policy
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy"
  description = "Allows reading, listing, and writing to the web_bucket bucket"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "s3:*"
      ],
      "Resource" : [
        aws_s3_bucket.web_bucket.arn,
        "${aws_s3_bucket.web_bucket.arn}/*",
      ]
    }]
  })

  tags = local.common_tags
}

# aws_iam_policy_attachment
resource "aws_iam_policy_attachment" "s3_access_attachment" {
  name       = "s3-access-attachment"
  roles      = [aws_iam_role.allow_nginx.name]
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# aws_iam_instance_profile
resource "aws_iam_instance_profile" "example_instance_profile" {
  name = "example-instance-profile"
  role = aws_iam_role.allow_nginx.name
}