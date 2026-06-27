module "network" {
  source = "./modules/network"
}
/*
module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id
}

module "registry" {
  source = "./modules/registry"
}

module "compute" {
  source = "./modules/compute"
}

module "load_balancing" {
  source = "./modules/load_balancing"
}

module "secrets" {
  source = "./modules/secrets"
}

module "storage" {
  source = "./modules/storage"
}*/