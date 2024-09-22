# Define the CIDR block for the Virtual Private Cloud (VPC)
# This will create a network with 65,536 available IP addresses (10.0.0.0 to 10.0.255.255)
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

# Define CIDR blocks for Public Subnets
# These subnets will have direct access to the internet via an Internet Gateway

# Public Subnet 1: 256 available IP addresses (10.0.1.0 to 10.0.1.255)
variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  default     = "10.0.1.0/24"
}

# Public Subnet 2: 256 available IP addresses (10.0.2.0 to 10.0.2.255)
variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  default     = "10.0.2.0/24"
}

# Define CIDR blocks for Private Subnets
# These subnets will not have direct access to the internet, typically used for backend services

# Private Subnet 1: 256 available IP addresses (10.0.3.0 to 10.0.3.255)
variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  default     = "10.0.3.0/24"
}

# Private Subnet 2: 256 available IP addresses (10.0.4.0 to 10.0.4.255)
variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  default     = "10.0.4.0/24"
}
