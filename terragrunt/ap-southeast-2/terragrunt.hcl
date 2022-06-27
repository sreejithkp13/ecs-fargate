terraform {
  source = "git::git@github.com:sreejithkp13/ecs-fargate.git//terraform/module?ref=v0.0.1"
}
inputs = {
    aws_region = "ap-southeast-2"
    app_name = "fargate-southeast"
    vpc_cidr = "172.17.0.0/16"
}