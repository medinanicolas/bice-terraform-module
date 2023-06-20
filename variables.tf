variable "bice_vpc_id" {
  description = "ID de la VPC de AWS para la aplicación de Elastic Beanstalk"
  type        = string
}

variable "bice_name_application" {
  description = "Nombre único de la aplicación de Elastic Beanstalk"
  type        = string
}

variable "bice_environment" {
  description = "Nombre único del ambiente de la aplicación de Elastic Beanstalk"
  type        = string
}

variable "bice_solution_stack_name" {
  description = "Solution Stack Name para la aplicación de Elastic Beanstalk (https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html)"
  type        = string
}
