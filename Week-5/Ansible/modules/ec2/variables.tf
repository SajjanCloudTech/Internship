variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}