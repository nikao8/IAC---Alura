terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" // região da aws mais barata
}

variable "my_ip" {
  # Liberando para todos a nivel de teste
  default = "0.0.0.0/0" // Ex: "189.45.67.89/32"
}

########### Extra passando criacao do SecurityGroup e adicionando regra de entrada para ssh no meuip ###########
resource "aws_security_group" "access_sg" {
  name        = "ssh-from-my-ip"
  description = "Allow SSH access from my IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "SSH Nicolas"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }


  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# Obter VPC padrão (necessário para associar o SG)
data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "ec2_instance_example" {
  ami                    = "ami-020cba7c55df1f615" // ubuntu t3.micro ami
  instance_type          = "t3.micro"
  key_name               = "iac-nicolas"
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
 
  tags = {
    Name = "Curso Ansible"
  }
}