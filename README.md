This include a Terraform module which is used for hosting a public nginx server with minimal configuraton using ECS Fargate, Auto Scalling and Application Load Balancer. We can use terragrunt for configure this module in both ap-southeast-2 and eu-west-1 regions.
This module is also using capacity provider strategy and the ratio of FARGATE to FARGATE_SPOT is 1:1.

