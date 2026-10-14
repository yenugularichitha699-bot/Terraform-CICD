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

  tags = {
    Name = "web-server"
  }
}
# trigger workflow