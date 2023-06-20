/*
Imprime la ip pública de la instancia EC2
*/
output "instance_ip_addr" {
  value = aws_instance.bice_ec2.public_ip
}
/*
Imprime la url del endpoint del Elastic Beanstalk
*/
output "environment_url" {
  value = aws_elastic_beanstalk_environment.bice_env.endpoint_url
}
