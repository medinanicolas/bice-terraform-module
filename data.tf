/*
Data Source AMI Ubuntu
Consigue el ID de la AMI de Ubuntu Server 20.04 HVM-SSD
*/
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
/*
Consigue el Grupo de Seguridad según VPC ID
*/
data "aws_security_group" "bice_sg" {
  vpc_id = var.bice_vpc_id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}
/*
Consigue un set de Subnets desde una VPC
*/
data "aws_subnets" "bice_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.bice_vpc_id]
  }
}
