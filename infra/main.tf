# Provider

provider "aws" {
    region = var.region
}

# Key-Pair Login

resource "aws_key_pair" "my_key"{
    key_name = "devops-server-key"
    public_key = file("devops-server-key.pub")
}

# Default VPC

resource "aws_default_vpc" "default"{

}

# Default Subnet

resource "aws_default_subnet" "default_az1" {
    availability_zone = "us-east-1a"
}

# Security Group

resource "aws_security_group" "my_sec_grp"{
    vpc_id = aws_default_vpc.default.id

    # Inbound Rule

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH open"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP open"
    }

    # Outbound Rule

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "all access open outbound"
    }
}

# EC2 Instance

resource "aws_instance" "my_instance"{
    key_name = aws_key_pair.my_key.key_name 
    vpc_security_group_ids = [aws_security_group.my_sec_grp.id]
    instance_type = var.ec2_instance_type
    ami = var.ec2_instance_image
    subnet_id = aws_default_subnet.default_az1.id

    # Storage 

    root_block_device{
        volume_size = var.ec2_instance_volume
        volume_type = var.ec2_instance_volume_type
    }

    # Name and Tags

    tags = {
        Name = "devops-server"
    }
}

# Elastic IP

resource "aws_eip" "my_eip" {
    instance = aws_instance.my_instance.id
    domain = "vpc"
}
