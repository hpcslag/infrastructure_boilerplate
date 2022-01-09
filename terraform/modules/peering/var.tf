variable "namespace" {
  type = string
}

variable "this_vpc_id" {
  type = string
}

variable "this_vpc_security_group_id" {
  type = string
}


variable "this_vpc_route_table_ids" {
  type = list(string)
}

variable "this_vpc_cidr" {
  type = string
}

variable "peer_vpc_id" {
  type = string
}

variable "peer_vpc_security_group_id" {
  type = string
}

variable "peer_vpc_route_table_ids" {
  type = list(string)
}

variable "peer_vpc_cidr" {
  type = string
}