/*
Crea una política de seguridad para los servicios utilizados.
*/
resource "aws_iam_policy" "bice_policy" {
  name        = "bice-policy"
  description = "Politica para IAM, S3, EC2, VPC, and Elastic Beanstalk"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*",
        "s3:*",
        "ec2:*",
        "ec2:CreateTags",
        "elasticbeanstalk:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
/*

*/
resource "aws_iam_role" "bice_iam_role" {
  name               = "bice-role"
  description        = "Rol para los servicios utilizados"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
/*
Adjuntar política a un rol
*/
resource "aws_iam_role_policy_attachment" "bice_policy_attachment" {
  policy_arn = aws_iam_policy.bice_policy.arn
  role       = aws_iam_role.bice_iam_role.name
}
/*
Crea un perfil y asigna el rol
*/
resource "aws_iam_instance_profile" "bice_profile" {
  name = "bice-profile"

  role = aws_iam_role.bice_iam_role.name
}
/*
Bice EC2
Crea la máquina necesaria para la implementación de la aplicación
*/
resource "aws_instance" "bice_ec2" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.bice_profile.name

  vpc_security_group_ids = [data.aws_security_group.bice_sg.id]

  tags = {
    Name  = "BiceEC2"
    Owner = "Nicolás Medina"
  }
}
/*
Bucket S3
Almacena el archivo comprimido ZIP del repositorio en el despliegue de GitHub Actions
*/
resource "aws_s3_bucket" "bice_bucket" {
  bucket = "bice-bucket"

  tags = {
    Name  = "BiceBucket"
    Owner = "Nicolás Medina"
  }
}
/*
Bice Elastic Beanstalk
Implementa la aplicación
*/
resource "aws_elastic_beanstalk_application" "bice_app" {
  name        = var.bice_name_application
  description = "Web App de Elastic Beanstalk - Nicolás Medina"
  tags = {
    Name  = "WebApp"
    Owner = "Nicolás Medina"
  }
}
/*
Bice Elastic Beanstalk Environment
Proporciona el ambiente configurable para la implementación de la aplicación
*/
resource "aws_elastic_beanstalk_environment" "bice_env" {
  name                = var.bice_environment
  description         = "Ambiente para la Web App de Elastic Beanstalk"
  application         = aws_elastic_beanstalk_application.bice_app.name
  solution_stack_name = var.bice_solution_stack_name
  //Asigna la VPC
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.bice_vpc_id
  }
  //Asigna las subnets
  dynamic "setting" {
    for_each = toset(data.aws_subnets.bice_subnets.ids)
    content {
      namespace = "aws:ec2:vpc"
      name      = "Subnets"
      value     = setting.value
    }
  }
  //Asigna el perfil
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.bice_profile.name

  }
  //tags
  tags = {
    Name  = "AmbienteWebApp"
    Owner = "Nicolás Medina"
  }
}
