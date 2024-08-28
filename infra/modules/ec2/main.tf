provider "aws" {
  region = "us-east-2"
}

# Criação da VPC
resource "aws_vpc" "airflow_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnet Pública
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.airflow_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.airflow_vpc.id
}

# Rota Pública
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.airflow_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

# Associação da Rota Pública com a Subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

# Security Group
resource "aws_security_group" "airflow_sg" {
  vpc_id = aws_vpc.airflow_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "airflow_sg"
  }
}


# Criação da Instância EC2
resource "aws_instance" "airflow_instance" {
  ami           = "ami-085f9c64a9b75eed5"  # AMI do Ubuntu
  iam_instance_profile = var.var_instance_profile
  instance_type = "t2.xlarge"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids =  [aws_security_group.airflow_sg.id]

  provisioner "local-exec" {
    command = "aws s3 cp ../app s3://novadrive-airflow-dbt-bucket/ --recursive"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y curl
              sudo apt-get install -y docker.io git
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo apt install unzip
              sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
              sudo unzip awscliv2.zip && \
              sudo ./aws/install && \
              sudo rm -rf awscliv2.zip aws
              
              curl -sSL https://install.astronomer.io | sudo bash

              sudo mkdir /home/ubuntu/app

              sudo aws s3 sync s3://${var.bucket_name} /home/ubuntu/app
              cd /home/ubuntu/app
              
              # Executando o script
              sudo astro dev start
            EOF

  tags = {
    Name = "airflow-astro-cli"
  }
}




output "instance_public_ip" {
  value = aws_instance.airflow_instance.public_ip
}

