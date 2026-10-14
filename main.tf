
resource "aws_security_group" "web_sg" {
  name        = "web-sg5-terraform"
  description = "Allow SSH and HTTP"
 
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
 
}
 
resource "aws_instance" "web5" {
 
  ami           = "ami-03d75ab52ca8481aa"
  instance_type = "t3.micro"
 
  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]
 
  associate_public_ip_address = true
 
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
<p>Website deployed using Terraform</p>
</body>
</html>
HTML
 
EOF
 
  tags = {
    Name = "web-server-2"
  }
}
 
output "public_ip" {
  value = aws_instance.web5.public_ip
}