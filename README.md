Deploying a Website with Nginx on AWS Using Terraform
This project helps you set up a web server on Amazon Web Services (AWS) using Terraform. We'll use a service called ECS (Elastic Container Service) to deploy a basic Nginx web server, which is a popular web server software. Everything will be automated using Terraform, which is a tool that makes managing infrastructure (like servers, networking, etc.) easier.

What Will We Create?
A secure network (called a VPC) to run everything inside.
A web server using Nginx deployed in a way that automatically manages and scales itself.
A load balancer that allows anyone to access your web server from the internet.
Even if you’re new to cloud computing or AWS, you should be able to follow along!

Prerequisites
Before you start, make sure you have:

Terraform installed on your computer. You can download it here.
An AWS Account to create resources on the cloud.
(Optional) AWS CLI installed for setting up access to AWS easily.


How to Set It Up
Follow these steps to get everything up and running!

1. Clone the Repository
First, download the project files from the GitHub repository. Run this command in your terminal:

bash
Copy code
git clone https://github.com/yourusername/ecs-terraform-setup.git
cd ecs-terraform-setup
2. Configure AWS Provider
In the file provider.tf, we tell Terraform which cloud provider we are using (in this case, AWS) and what region (data center) to use. You can leave this as is, or change the region if you prefer a different location.

hcl
Copy code
provider "aws" {
  region = "us-east-1"  # Change this to your AWS region if needed
}
3. How the Web Server Is Set Up (ECS)
The file ecs-cluster.tf contains everything needed to set up a web server (Nginx) on AWS. Here's what it does:

ECS Cluster: Think of this as a space where your web servers live. It’s where your web app runs.
Task Definition: This defines the Nginx web server. It’s like a recipe that says "Run this web server using this image."
ECS Service: This keeps your web server running and makes sure there’s always the right number of web servers running.
You don’t need to understand every line of code here. Just know that it will deploy an Nginx server in a managed way.


4. Security Setup
To make sure our server is safe, we create security groups that control who can access the server. Think of them like firewalls.



5. Deploy Your Website!
Once everything is set up, you can deploy your website by running these commands:

Initialize Terraform: This will set up your environment and download necessary providers.

bash
Copy code
terraform init
Validate the Setup: Check that everything is correct.

bash
Copy code
terraform validate
Apply the Setup: This command will create everything in your AWS account. You’ll be asked to confirm by typing yes.

bash
Copy code
terraform apply
Terraform will now create all the required resources: the network, ECS cluster, web server, and load balancer.

6. Access Your Website
Once Terraform finishes, it will give you the URL for the Application Load Balancer (ALB). You can access your website by visiting this URL in a web browser!

bash
Copy code
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.ecs_alb.dns_name
}


7. Clean Up When Done
To avoid ongoing costs in your AWS account, you can remove everything once you’re done testing. Just run:

bash
Copy code
terraform destroy
This will delete all the resources that were created.

Summary
VPC: This is your isolated network in AWS.
ECS: AWS service that runs your web server.
Fargate: AWS handles running your server, so you don’t have to worry about managing physical machines.
ALB: The Load Balancer that allows users to access your web server.
Concepts Explained for Beginners:
VPC (Virtual Private Cloud): A private, secure space on AWS where all your resources live.
ECS (Elastic Container Service): A service that runs applications in Docker containers. In this case, it’s running Nginx, a web server.
Fargate: A feature of ECS where AWS manages the server for you. You don’t need to think about hardware.
Load Balancer: This spreads traffic across your servers and helps make your website available to the internet.