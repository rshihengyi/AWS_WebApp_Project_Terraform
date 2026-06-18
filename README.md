<h1>AWS Static Portfolio Web Application Project Summary</h1>
The aim of this project is to automate the deployment of a containerized static webpage into an AWS cloud architecture provisioned in Terraform using CI/CD pipelines with GitHub Actions. The project is split into two parts, infrastructure and app deployment automation which is done with both the AWS_WebApp_Project_Terraform
and AWS_WebApp_Project repositories. 

<h1>AWS Web Application Infrastructure (Terraform)</h1>
This repository contains the Terraform code that creates the infrastructure of the Web Application to be hosted in and configures the internal network necessary for the AWS components to communicate properly. IAM roles needed for workflows from this repository and the AWS_WebApp_Project repository are also created with Terraform. Below is the list of AWS components created with Terraform. 

*Note: The S3 bucket for the remote state backend was manually created as a bootstrap step since provisioning it with Terraform creates circular dependency and adds additional complexity for its purpose. The backend.tf simply stores the .tfstate file once Terraform is initialized locally (terraform init -migrate-state)

<h1>Web Application Infrastructure Components</h1>

- VPC
- EC2
- Security Groups
- Application Load Balancer
- Route 53
- ACM Certification: certificate for dev.robs-portfolio.com
- IAM Roles (SSM Agent, EC2, GitHub Actions)

<h1>Full Architecture Flow Chart</h1>
<img width="2047" height="1527" alt="image" src="https://github.com/user-attachments/assets/9ac012c1-23ab-491e-b383-092b4b964996" />

<h1>Project Documentation</h1>
https://1drv.ms/w/c/d18af1f250bff2cb/IQDDwiEVOjUtRrKC2TQTrDk_AU5VjMMQKTsa0N9dgRNVQzA?e=kSSxlt
