#-----------------------------------------------------------------------------------------------
# Create firewall VPCs & subnets
module "vpc0" {
  source = "./modules/vpc/"
  vpc                   = var.vpc0
  subnet                = var.vpc0_subnet
  cidr                  = var.vpc0_cidr
  region                = var.region
  allowed_sources       = ["0.0.0.0/0"]
}

module "vpc1" {
  source = "./modules/vpc/"
  vpc                   = var.vpc1
  subnet                = var.vpc1_subnet
  cidr                  = var.vpc1_cidr
  region                = var.region
  allowed_sources       = var.mgmt_sources
  allowed_protocol      = "TCP"
  allowed_ports         = ["443", "22"]
}

module "vpc2" {
  source = "./modules/vpc/"
  vpc                  = var.vpc2
  subnet               = var.vpc2_subnet
  cidr                 = var.vpc2_cidr
  region               = var.region
  allowed_sources      = ["0.0.0.0/0"]
}

module "vpc3" {
  source = "./modules/vpc/"
  vpc                  = var.vpc3
  subnet               = var.vpc3_subnet
  cidr                 = var.vpc3_cidr
  region               = var.region
  allowed_sources      = ["0.0.0.0/0"]
  delete_default_route = true
}
