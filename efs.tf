## EFS File System ##

resource "aws_efs_file_system" "primary" {
  creation_token = "primary"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = "true"

  tags = {
    Name = "${var.efsname1}"
  }
}

## EFS Mount Target ##

resource "aws_efs_mount_target" "primarymount" {
   file_system_id  = "${aws_efs_file_system.primary.id}"
   subnet_id = "${var.Subnet_IdPrimary}"
   security_groups = ["${aws_security_group.primaryefs-sg.id}"]
 }

## EFS Security Group ##

resource "aws_security_group" "primaryefs-sg" {
   vpc_id = "${var.VPC_id}"

   // NFS
   ingress {
     from_port = 2049
     to_port = 2049
     protocol = "tcp"
     cidr_blocks = "${var.allowed_hosts}"     
   }

   // Terraform removes the default rule
   egress {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = "${var.allowed_hosts}"
   }
 }


#### Instance Config #####

resource "aws_instance" "instance1" {
  ami             = "${var.amiprimary}"
  instance_type   = "${var.instance_typeprimary}"
  subnet_id       = "${var.subnetprimary}"
  key_name        = "${var.keyprimary}"
  user_data       = <<-EOT
   #!/bin/bash
    sleep 5m
    # Install AWS EFS Utilities
    sudo yum install -y amazon-efs-utils
    # Mount EFS
    sudo mkdir -p /var/lib/elasticsearch
    efs_id="${aws_efs_file_system.primary.id}"
    sudo mount -t efs $efs_id:/ /var/lib/elasticsearch
    # Edit fstab so EFS automatically loads on reboot
    sudo echo $efs_id:/ /var/lib/elasticsearch efs defaults,_netdev 0 0 >> /etc/fstab
    EOT

   security_groups = ["${aws_security_group.primary_sg.id}"]
   tags = {
    Name      = "${var.primaryinstancetag}"
    Terraform = "true"
  }

    volume_tags = {
    Name      = "EFS_PRIMARY"
    Terraform = "true"
  }
}

#### Instance Security Group ####

resource "aws_security_group" "primary_sg" {
  name   = "landingzone-DRprimary-securitygroup"
  vpc_id = "${var.VPC_id_primary}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = "${var.allowed_hosts}"
  }

 ingress {
    protocol    = "tcp"
    from_port   = 2049
    to_port     = 2049
    cidr_blocks = "${var.allowed_hosts}"
  }

 ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = "${var.allowed_hosts}"
  }

 egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = "${var.allowed_hosts}"
  }

}

