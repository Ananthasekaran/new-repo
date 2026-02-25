provider "aws" {
  region = "ap-south-1"   # Mumbai region
}

# ------------------ KEY PAIR ------------------

resource "aws_key_pair" "deployer" {
  key_name   = "newssss"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHEUl3WWWPOJKfMekrHhqCjkg00zX85YlF4lUURw5Ax4Fh7uPQ4G6xTJUTAKrUr/DIPv+HEV0E66MwZtSSvtpg88p08pejP2ZUh3rdEJnkrz+d0dMbw+NVh4Hydf+HFNBB9whvdygY/GYMVmmORA8D7H1eevl8mjlg1VoWLKhyHzK/mlbor6AGGTCVxyzh1StJL3b72yLsWU5u3NTTXpo1oWTJ0ONYDrAmmd1Q05VtUCMvzlrghHGd6FUjz4vGqlA7n2jexrE27Tn/TH556kCsNMcm3Q7K527uJojkJyA6nwWNJ5cnbCT0zMj21oai45jwfR4W7/G6KnyIz1opgbKXeThRnZc98JFEt31+nPY/s1pDf6mrFLEqJT8pt+g8Qsdtzfo58VIfVfBf1q6ea64qUvJcCqCxwZEIbaAIY6v1yAVadt11zlyLyk+XJ1qrij4znFvSqgkJ1BUBK4Gl7VzoLGI3Lv7JxXYzrz63pPTKTu3l5sQCNwlLldKfRILE/ikuL8Tp4qeN8ppNbq0OuDRN1RE5UNt378GksqBBeS/W2vhZki+lTDADfwjpVbSlVuBinBNJHdMtBW//5Ly+n8WLV2XUz9QMj1GtrdK5emYBJtoIA8oXzMDUmcrnOmpiTK9Ac69J7YNmZIYdL5sWYi1z1zNxCbKRxohMnj/O7O+uBw== root@ip-172-31-22-86"
}

# ------------------ SECURITY GROUP ------------------

resource "aws_security_group" "allow_ports" {
  name        = "allow_ssh_http_newssss"
  description = "Allow SSH, HTTP, and Jenkins"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Ananth-SG"
  }
}

# ------------------ EC2 INSTANCE ------------------

resource "aws_instance" "ubuntu" {
  ami           = "ami-0f5ee92e2d63afc18"  # Ubuntu 22.04 Mumbai
  instance_type = "t3.micro"

  key_name        = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_ports.id]

  tags = {
    Name = "Ananth-EC2"
  }
}

# ------------------ OUTPUTS ------------------

output "instance_public_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "instance_id" {
  value = aws_instance.ubuntu.id
}
