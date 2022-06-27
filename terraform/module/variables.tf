variable "vpc_cidr" {
  description = "Application Name "
  default     = "172.17.0.0/16"
}
variable "app_name" {
  description = "Application Name "
  default     = "fargate-ecs-app"
}
variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-2"
}
variable "capacity_provider_strategy" {
  type        = list(any)
  description = "capacity_provider list" 
  default     = [{
    capacity_provider = "FARGATE"
    weight            = "1"
    base              = "1"
 },
 {
    capacity_provider = "FARGATE_SPOT"
    weight            = "1"
    base              = "0"
 }]
}
variable "az_count" {
  description = "Number of AZs"
  default     = "2"
}

variable "app_image" {
  description = "Docker image"
  default     = "nginx:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory"
  default     = "2048"
}