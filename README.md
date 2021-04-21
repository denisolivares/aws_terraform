# AWSLabs Challenge
Deployment of an AWS infrastructure using Terraform

This challenge requires you to create a new VPC in the AWS cloud.

## Description
VPC will requires 2 subnets, one subnet will have internet connectivity (Webserver) and second will be without internet
connectivity (Database).

Both subnets should be able to talk each other through the default routing table but this challenge will require security groups to be configured on specific ports.

## Infrastructure data
- VPC Name/CIDR: awslab-vpc 172.16.0.0/16
- Subnet Name/CIDR: awslab-subnet-public 172.16.1.0/24
- Internet Gateway Connectivity: Yes
- Routing Table: awslab-rt-internet
- Subnet Name : awslab-subnet-private 172.16.2.0/24
- Internet Gateway Connectivity: No
- Availability Zone : US- East-2a (or equivalent)
- EC2 Instances: Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type, ami-023c8dbf8268fb3ca
- Storage size: 8GB (Default)
- Security Group Public Ports: HTTP/ICMP/SSH

### Security Group Public Ports: HTTP/ICMP/SSH
| Type          | Protocol      | Port    | Source        | Address       | Comments      |
| ------------- |:-------------:|:-------:| ------------- | ------------- | ------------- |
| HTTP          | TCP           | 80      | CUSTOM        | 0.0.0.0/0     | ------------- |
| ICMP          | ICMP          | 0-65535 | Anywhere      | 0.0.0.0/0     | ------------- |
| SSH           | TCP           | 22      | Anywhere      | 0.0.0.0/0     | ------------- |

### Security Group Private Ports: Custom DB Port/ICMP/SSH
| Type          | Protocol      | Port    | Source        | Address       | Comments      |
| ------------- |:-------------:|:-------:| ------------- | ------------- | ------------- |
| CUSTOM        | TCP           | 3110    | CUSTOM        | 172.16.1.0/24 | ------------- |
| ICMP          | ICMP          | 0-65535 | Anywhere      | 0.0.0.0/0     | ------------- |
| SSH           | TCP           | 22      | CUSTOM        | 172.16.1.0/24 | ------------- |

# Challenge evolution

1. ✔️ Create a trial (free) account in AWS 
    - Created a temporary Gmail account to create the AWS account.
    - Configured MFA on the root account
    - Created a new user and attached only the `SystemAdministrator` policy to it
    - Generated AWS Key for programmatic access for this new user, in order to use terraform over awscli
2. ✔️ Setup a new VPC using the details above
3. ✔️ Create Routing table
    - Created two differente routing tables:
        - `awslab_rt_public` for public network (webservers)
        - `awslab_rt_private` for private network (databases)
4. ✔️ Configure and attach Internet Gateway
    - `awslab_igw` was created and attached to `awslab_rt_public`
5. ✔️ Configure security groups
    - `awslab_sg_public` for public hosts (webservers)
    - `awslab_sg_private` for private hosts (databases)
6. ✔️ Create EC2 instance (Red Hat AMI) for webserver Public
7. ✔️ Create EC2 instance (Red Hat AMI) for database Private
8. ✔️ Please use your preferred IAC tool and send to us the Github address to the code
    - Used `Terraform`
9. ✔️ Provide .PEM file to the email that sent you the challenge

# Running the AWSLab infrastructure
- Clone this repository
- Setup the AWS credentials created for this challenge
- Save the `.pem` (received via e-mail) on this project directory
- Check/adjust the permissions for the `.pem` file
    - `chmod 400 file_name.pem` will adjust it accordingly
- Run `terraform init` to inialize the terraform
- Then, run `terraform plan` and check the plan output
- Now, run `terraform apply` (you can add `--auto-approve`, if you're bold)
- You're doing great! We have some time until terraform is done, how about drink some water?
- When terraform is done, it will output the public and private IP adressess from the webserver and the private IP address from the database
- You ca use the terraform output to note the webserver public IP address and quickly connect to it
    - `ssh ec2-user@webserver_public_ip -i file_name.pem`
    - Testing connection on port 3110:
        - Connect on the database host 
        - Run the command `nc -l 3110` to create a listening service on database host
        - Leave the above session running and open a new terminal session
        - Connect on the webserver host
        - Then, run `telnet database_ip_address` to check if the connection is established

# Personal observations
Additional points that I would consider from the beginning for an infrastructure like the one suggested above:
- A load balancer for the webserver
- A load balancer for the database
- Minimum of three running instances for both webservers and databases
- A S3 bucket for images/documents store
- A EFS for the webserver files

# Reference
https://registry.terraform.io/providers/hashicorp/aws/latest/docs