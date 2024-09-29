
resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr # VPC IP range
  tags = {
    Name = var.vpc_name
  }
}
