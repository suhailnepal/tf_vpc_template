module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.16.1"

  name               = "${var.env}-vpc"
  cidr               = var.cidr_range
  azs                = var.availibility_zone
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  enable_nat_gateway = false
  enable_vpn_gateway = false
}