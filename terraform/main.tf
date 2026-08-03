module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
  
}

module "kubernetes" {
  source             = "./kubernetes"
  cluster_name       = "forever-kubernetes-eks"
  vpc_id             = module.networking.forever_vpc_id
  subnet_ids         = module.networking.forever_private_subnets
  node_instance_type = "t3.small"
}
