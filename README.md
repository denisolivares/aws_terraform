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