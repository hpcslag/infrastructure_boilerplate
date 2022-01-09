variable "region" {
  type        = string
  description = "AWS region"
}

variable "instance_type" {
  type        = string
  description = "Instance type to use"
  default = "db.t3.medium"
}

variable "cluster_size" {
  type        = number
  description = "Number of DB instances to create in the cluster"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "publicly_accessible" {
  type = bool
  default = false
}

variable "admin_user" {
  type        = string
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "admin_password" {
  type        = string
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user"
}

variable "cluster_family" {
  type        = string
  description = "The family of the DB cluster parameter group"
  default     = "aurora-postgresql12" # only 10.11 support global, 13 is single master aws rds describe-db-engine-versions --query "DBEngineVersions[].DBParameterGroupFamily"
}

variable "engine" {
  type        = string
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
  default = "aurora-postgresql"
}

variable "deletion_protection" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled"
}

variable "autoscaling_enabled" {
  type        = bool
  description = "Whether to enable cluster autoscaling"
}

variable "all_traffic_cidrs" {
  type = list(string)
  default = [ "114.33.158.98/32" ]
}

variable "vpc_cidr_prefix16" {
  type = string
  default = "10.0"
}