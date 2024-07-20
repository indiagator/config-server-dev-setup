terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.57.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-south-1"
}

variable "existing_security_group_id" {
  description = "The ID of the existing security group"
  type        = string
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c2af51e265bd5e0e"
  instance_type = "t2.micro"
  key_name = "terratest"
  vpc_security_group_ids = [var.existing_security_group_id]

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_db_instance" "postgres_db" {
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "14.12"
  instance_class      = "db.t3.micro"
  username            = "postgres"
  password            = "postgres"
  db_subnet_group_name = aws_db_subnet_group.private_subnets.name
  vpc_security_group_ids = [aws_security_group.allow_postgres.id]
  skip_final_snapshot = true
  publicly_accessible = true
}

resource "aws_db_subnet_group" "private_subnets" {
  name       = "main_private_subnets"
  subnet_ids = ["subnet-53f60928", "subnet-5937e014", "subnet-8f6efee6"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres"
  description = "Allow inbound postgres traffic"
  vpc_id      = "vpc-7f0e9816"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

