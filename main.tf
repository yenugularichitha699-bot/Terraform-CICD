resource "aws_security_group" "web_sg" {
  name = "web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web1" {
  ami           = "ami-03d75ab52ca8481aa"
  instance_type = var.instance_type

  security_groups = [
    aws_security_group.web_sg.name
  ]

  user_data = <<-EOF
#!/bin/bash

dnf update -y
dnf install nginx -y

systemctl enable nginx
systemctl start nginx

cat > /usr/share/nginx/html/index.html <<HTML
<!DOCTYPE html>
<html>
<head>
    <title>Terraform CI/CD Demo</title>
</head>
<body>
    <h1>Welcome to Terraform CI/CD Demo</h1>
    <p>Website deployed automatically using Terraform and GitHub Actions.</p>
</body>
</html>
HTML

EOF

  tags = {
    Name = "web-server"
  }
}