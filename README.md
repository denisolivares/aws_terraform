# aws_terraform
Deployment of an AWS infrastructure using Terraform

# Steps

1. Create a trial (free) account in AWS ✔️
1. - Created a temporary Gmail account to create the AWS account ✔️
2. Setup a new VPC using the details above
2. - VPC Name / CIDR: awslab-vpc 172.16.0.0/16 ✔️
3. Configure and attach Internet gateway ❌
4. Create Routing table
4. - Routing Table: awslab-rt-internet ❌
5. Configure security groups
5. - Public ✔️
5. - Private ✔️
6. Create EC2 instance (Red Hat AMI) for webserver Public; ✔️
7. Create EC2 instance (Red Hat AMI) for database Private; ✔️
8. Please use your preferred IAC tool and send to us the Github address to the code
9. Provide .PEM file to the email that sent you the challenge

# Reference
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group