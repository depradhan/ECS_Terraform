# Security group for ECS tasks (private subnet)
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main_vpc.id # Associate this security group with the main VPC

  # Ingress rule: Allow inbound HTTP traffic from the ALB
  ingress {
    description     = "Allow HTTP traffic from the ALB"
    from_port       = 80                             # Start of port range
    to_port         = 80                             # End of port range (same as from_port for single port)
    protocol        = "tcp"                          # TCP protocol
    security_groups = [aws_security_group.alb_sg.id] # Reference to ALB security group
  }

  # Egress rule: Allow all outbound traffic
  egress {
    from_port   = 0             # Start of port range (0 means all ports)
    to_port     = 0             # End of port range (0 means all ports)
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic to any IPv4 address
  }

  # Tag the security group for easier identification
  tags = {
    Name = "ecs-task-sg"
  }
}

# Security group for the Application Load Balancer (ALB) in public subnet
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main_vpc.id # Associate this security group with the main VPC

  # Ingress rule: Allow inbound HTTP traffic from anywhere
  ingress {
    description = "Allow inbound HTTP traffic"
    from_port   = 80            # Start of port range
    to_port     = 80            # End of port range (same as from_port for single port)
    protocol    = "tcp"         # TCP protocol
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from any IPv4 address
  }

  # Egress rule: Allow all outbound traffic
  egress {
    from_port   = 0             # Start of port range (0 means all ports)
    to_port     = 0             # End of port range (0 means all ports)
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic to any IPv4 address
  }

  # Tag the security group for easier identification
  tags = {
    Name = "alb-sg"
  }
}
