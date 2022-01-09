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

variable "db_allocated_storage" {
  type    = number
  default = 5
}

variable "db_mysql_version" {
  type    = string
  default = "8.0"
}

variable "db_username" {
  type    = string
}

variable "db_password" {
  type = string
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
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
