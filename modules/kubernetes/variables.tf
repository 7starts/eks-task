variable "aws_subnets" {
  description = "CIDR range"
  type        = list
}

variable "cluster_name" {
  description = "CIDR range"
  type        = string
}

variable "desired_capacity" {
  default = 2
}

variable "max_capacity" {
  default = 2
}

variable "min_capacity" {
  default = 1
}

variable "account" {
  type = string
  sensitive = true
}
