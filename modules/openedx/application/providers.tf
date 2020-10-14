provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

// See mysql.tf

# provider "mysql" {
#   endpoint = module.rds.database.endpoint
#   username = module.rds.database.username
#   password = module.rds.database.password

#   alias = "aws_rds"
# }
