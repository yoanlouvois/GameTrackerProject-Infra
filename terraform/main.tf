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

module "registry" {
  source = "./modules/registry"

  project_name = var.project_name
  environment  = var.environment
}

module "storage" {
  source = "./modules/storage"

  project_name = var.project_name
  environment  = var.environment
}

module "secrets" {
  source = "./modules/secrets"

  project_name = var.project_name
  environment  = var.environment

  spring_datasource_url      = var.spring_datasource_url
  spring_datasource_username = var.spring_datasource_username
  cloudinary_cloud_name      = var.cloudinary_cloud_name
  cloudinary_api_key         = var.cloudinary_api_key

  spring_datasource_password = var.spring_datasource_password
  mysql_root_password        = var.mysql_root_password
  cloudinary_api_secret      = var.cloudinary_api_secret
  jwt_secret                 = var.jwt_secret
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment

  front_repository_arn = module.registry.front_repository_arn
  back_repository_arn  = module.registry.back_repository_arn

  backend_secret_arn = module.secrets.backend_secret_arn
  mysql_secret_arn   = module.secrets.mysql_secret_arn

  mysql_backups_bucket_arn = module.storage.mysql_backups_bucket_arn

  github_repositories = var.github_repositories
}

/*
    module "security" {
    source = "./modules/security"

    vpc_id = module.network.vpc_id
    }

    module "compute" {
    source = "./modules/compute"
    }

    module "load_balancing" {
    source = "./modules/load_balancing"
    }

*/