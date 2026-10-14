resource "aws_security_group" "web_sg" {
  name = "web-sg1-terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
}


resource "aws_instance" "web2" {
  ami           = "ami-03d75ab52ca8481aa"
  instance_type = var.instance_type

  security_groups = [
    aws_security_group.web_sg.name
  ]

  user_data_replace_on_change = true

  user_data = <<-EOF
#!/bin/bash
dnf update -y
dnf install nginx -y
systemctl enable nginx
systemctl start nginx

cat > /usr/share/nginx/html/index.html <<HTML
<!DOCTYPE html>
<html>
<body>
<h1>Welcome to Terraform CI/CD Demo</h1>
<p>Website deployed using GitHub Actions and Terraform</p>
</body>
</html>
HTML
EOF

  tags = {
    Name = "web-server"
  }
}