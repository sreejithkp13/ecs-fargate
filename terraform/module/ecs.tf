resource "aws_ecs_cluster" "aws_ecs_cluster" {
  name = "${var.app_name}-cluster"
  capacity_providers  = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight = 1
    base = 1
  }
}
data "template_file" "myapp" {
  template = file("./templates/ecs/myapp.json.tpl")
  vars = {
    app_name       = var.app_name
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}
resource "aws_ecs_task_definition" "app" {
  family                   = "myapp-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp.rendered
}

resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.aws_ecs_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
    }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group.id
    container_name   = "myapp"
    container_port   = var.app_port
  }
  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}