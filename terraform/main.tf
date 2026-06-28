module "network" {
  source = "./modules/network"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr                  = var.vpc_cidr
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_app_subnet_cidrs  = var.private_app_subnet_cidrs
  private_data_subnet_cidrs = var.private_data_subnet_cidrs
  availability_zones        = var.availability_zones
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.network.vpc_id
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