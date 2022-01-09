module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.28.1"

  cidr_block = "172.16.0.0/16"
  tags       = local.tags

  context = module.this.context

  name = "eks-cluster"

  dns_hostnames_enabled = true
  dns_support_enabled  = true
  internet_gateway_enabled = true
}