# Specify the provider
provider "aws" {
  profile	= "default"
  region	= "us-west-1"
}

# security group
resource "aws_security_group" "rrtfsgrp" {
	name = "rrtfsgrp"
        description = "allowing ssh and http traffic"
        
	# ingress rules
        ingress {
			from_port = 22
			to_port = 22
			protocol = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
		}


        ingress {
			from_port = 80 
			to_port = 80
			protocol = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
		}


        ingress {
			from_port = 8080 
			to_port = 8080
			protocol = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
		}


        # egress rules

        egress {
			from_port = 0 
			to_port = 0 
			protocol = "-1"
			cidr_blocks = ["0.0.0.0/0"]
		}
}


# instance
resource "aws_instance" "rrtfinst01" {
    ami                          = "ami-0e3c30a614395d894"
    availability_zone            = "us-west-1c"
    instance_type                = "t2.micro"
    security_groups              = [aws_security_group.rrtfsgrp.id]
    subnet_id                    = "subnet-04e4f5822d68240e6"
    key_name                     = "linux_ec2_openssh"
    tags = {
		Name = "tf-webserver"
           }
    user_data = file("install_apache.sh") 
}

# EIP
resource "aws_eip" "rrtfinst01-eip" {
	instance = aws_instance.rrtfinst01.id
	tags = { 
		Name = "rrtfinst01-eip"
		}
}

# create volume
resource "aws_ebs_volume" "ebsvol" {
  availability_zone              = "us-west-1c"
  size                           = 2
  tags                           = {
                                     Name = "EBSVOL1"
                                   }
}

#attach volume
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.ebsvol.id
  instance_id = aws_instance.rrtfinst01.id
}

