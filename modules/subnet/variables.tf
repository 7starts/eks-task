variable "subnet_cidrs" {
  description = "A list of subnet CIDR blocks."
  type        = list(string)
}

variable "vpc_id" {
  description = "A list of subnet CIDR blocks."
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones for the subnets."
  type        = list(string)
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
}