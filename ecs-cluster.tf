# Create ECS Cluster
# This resource defines an Amazon ECS cluster to group and manage your containers
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster"

  tags = {
    Name = "my-ecs-cluster"
  }
}

# Define ECS Task Definition
# This resource specifies the containers to be run and their requirements
resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task" # Logical group of task definitions
  network_mode             = "awsvpc"     # Use AWS VPC networking mode
  requires_compatibilities = ["FARGATE"]  # Use Fargate launch type

  # Reference the existing ECS Task Execution Role
  # This role allows ECS to pull container images and publish logs to CloudWatch
  execution_role_arn = "arn:aws:iam::326482812648:role/ecsTaskExecutionRole"

  # Specify CPU and memory requirements
  cpu    = "256"
  memory = "512"

  # Define the container(s) to run in the task
  container_definitions = jsonencode([
    {
      name      = "nginx-container"
      image     = "public.ecr.aws/docker/library/nginx:stable-alpine3.20-perl"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

# ECS Service to Run the Task Definition
# This resource ensures that the specified number of tasks are running at all times
resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1 # Number of instances of the task to run

  # Configure the network for the tasks
  network_configuration {
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false # Tasks use private subnets, no public IP needed
  }

  # Integrate the service with a load balancer
  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_tg.arn
    container_name   = "nginx-container"
    container_port   = 80
  }

  # Ensure the listener is created before the service
  depends_on = [
    aws_lb_listener.http_listener
  ]
}

# Create an Application Load Balancer (ALB)
# This distributes incoming application traffic across multiple targets
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false # Internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "ecs-alb"
  }
}

# Create a Target Group for ECS Service
# This defines where to route requests to the ECS tasks
resource "aws_lb_target_group" "nginx_tg" {
  name        = "nginx-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "ip" # Use 'ip' as target type for Fargate tasks

  # Configure health checks to ensure targets are healthy
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    protocol            = "HTTP"
  }

  tags = {
    Name = "nginx-tg"
  }
}

# Create a Listener for ALB (HTTP traffic)
# This checks for connection requests and routes traffic based on the rules
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  # Default action to forward traffic to the target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }

  tags = {
    Name = "http-listener"
  }
}
