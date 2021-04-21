# aws_terraform
Deployment of an AWS infrastructure using Terraform

VPC Name / CIDR: awslab-vpc 172.16.0.0/16
Subnet Name / CIDR: awslab-subnet-public 172.16.1.0/24
Internet Gateway Connectivity: Yes
Routing Table: awslab-rt-internet
Subnet Name : awslab-subnet-private 172.16.2.0/24
Internet Gateway Connectivity: No
Availability Zone : US- East-2a (or equivalent)
EC2 Instances: Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type - ami-023c8dbf8268fb3ca
Storage size: 8GB (Default)

Steps

1. Create a trial (free) account in AWS; ✔️
1. - Created a temporary Gmail account to create the AWS account; ✔️
2. Setup a new VPC using the details above; ✔️
3. Configure and attach Internet gateway
4. Create Routing table
5. Configure security groups; ✔️
6. Create EC2 instance (Red Hat AMI) for webserver Public; ✔️
7. Create EC2 instance (Red Hat AMI) for database Private; ✔️
8. Please use your preferred IAC tool and send to us the Github address to the code
9. Provide .PEM file to the email that sent you the challenge