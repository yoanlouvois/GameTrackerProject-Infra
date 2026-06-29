aws_region   = "eu-west-3"
project_name = "gametracker"
environment  = "dev"

vpc_cidr = "10.0.0.0/16"

availability_zones = [
  "eu-west-3a",
  "eu-west-3b"
]

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_app_subnet_cidrs = [
  "10.0.10.0/24",
  "10.0.11.0/24"
]

private_data_subnet_cidrs = [
  "10.0.20.0/24",
  "10.0.21.0/24"
]

spring_datasource_url      = "jdbc:mysql://IP_PRIVEE_MYSQL:3306/db_pgt?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"
spring_datasource_username = "test"

cloudinary_cloud_name = "xxx"
cloudinary_api_key    = "xxx"

spring_datasource_password = "xxx"
mysql_root_password        = "xxx"
cloudinary_api_secret      = "xxx"
jwt_secret                 = "xxx"

github_repositories = [
  "yoanlouvois/GameTrackerProject-Backend",
  "yoanlouvois/GameTrackerProject-Frontend"
]