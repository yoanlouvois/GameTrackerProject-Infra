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

module "load_balancing" {
  source = "./modules/load_balancing"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
}

module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  private_app_subnet_ids  = module.network.private_app_subnet_ids
  private_data_subnet_ids = module.network.private_data_subnet_ids

  front_sg_id = module.security.front_sg_id
  back_sg_id  = module.security.back_sg_id
  mysql_sg_id = module.security.mysql_sg_id

  front_instance_profile_name = module.iam.front_instance_profile_name
  back_instance_profile_name  = module.iam.back_instance_profile_name
  mysql_instance_profile_name = module.iam.mysql_instance_profile_name

  front_repository_url = module.registry.front_repository_url
  back_repository_url  = module.registry.back_repository_url

  front_target_group_arn = module.load_balancing.front_target_group_arn
  back_target_group_arn  = module.load_balancing.back_target_group_arn

  mysql_backups_bucket_name = module.storage.mysql_backups_bucket_name
}