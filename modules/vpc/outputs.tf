output "vpc_arn" {
  description = "The created VPC ID."
  value       = aws_vpc.my_vpc.arn
}

output "vpc_id" {
  description = "The created VPC ID."
  value       = aws_vpc.my_vpc.id
}

output "vpc_name" {
  description = "The created VPC ID."
  value       = var.vpc_name
}