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
resource "aws_security_group" "access_wordpress" {
  name        = "access-wordpress-sg"
  description = "Allow access to WordPress"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "SSH Ansible"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  ingress {
    description      = "HTTP access"
    from_port        = 80
    to_port          = 80
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


resource "aws_security_group" "access_mysql" {
  name        = "access-mysql-sg"
  description = "Allow access to Wordpress MySQL"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "SSH Ansible"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  ingress {
    description                = "MYSQL access from WordPress"
    from_port                  = 3306
    to_port                    = 3306
    protocol                   = "tcp"

    #com security groups nao tava funcionando, avaliar depois
    #security_groups            = [aws_security_group.access_wordpress.id]  # aqui liberamos atraves do security group do wordpress, ou seja, quem estiver naquele sg sera liberado neste
    
    cidr_blocks   = ["${aws_instance.ec2_instance_wordpress.public_ip}/32"]
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

resource "aws_instance" "ec2_instance_wordpress" {
  ami                    = "ami-020cba7c55df1f615" // ubuntu t3.micro ami
  instance_type          = "t3.micro"
  key_name               = "iac-nicolas"
  vpc_security_group_ids = [aws_security_group.access_wordpress.id]
 
  tags = {
    Name = "Curso Ansible - Wordpress"
  }
}

resource "aws_instance" "ec2_instance_mysql" {
  ami                    = "ami-020cba7c55df1f615" // ubuntu t3.micro ami
  instance_type          = "t3.micro"
  key_name               = "iac-nicolas"
  vpc_security_group_ids = [aws_security_group.access_mysql.id]
 
  tags = {
    Name = "Curso Ansible - Mysql"
  }
}