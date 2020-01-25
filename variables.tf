variable "efsname1" {
description = "Name of Primary Region efs"
}

variable "Subnet_IdPrimary" {
description = "Subnet in which Primary EFS Mount target is set"
}

variable "amiprimary" {
description = "Ami used to create Primary Instance"
}

variable "instance_typeprimary" {
description = "Instance type used to create Primary Instance"
}

variable "subnetprimary" {
description = "Subnet used to create Primary Instance"
}

variable "keyprimary" {
description = "Key used to create Primary Instance"
}

variable "VPC_id_primary" {
description = "VPC id used to create Primary Instance"
}

variable "primaryinstancetag" {
description = "Tag value for Primary Instance"
}

variable "allowed_hosts" {
type = "list"
description = "Ingress and egress traffic allowed from these hosts"
}

variable "VPC_id" {
}
