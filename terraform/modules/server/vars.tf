variable "aws_region" {
  type = string
}

variable "namespace" {
  type    = string
  #default = "staging"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type = string
}

variable "deployment_group_name" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "all_traffic_cidrs" {
  type = list(string)
  default = [ "114.33.158.98/32" ]
}

variable "vpc_cidr_prefix16" {
  type = string
  default = "10.0"
}