module "mongodb" {
  source = "../mongodb"

  mongodbatlas_project_id  = var.mongodbatlas_project_id
  mongodbatlas_public_key  = var.mongodbatlas_public_key
  mongodbatlas_private_key = var.mongodbatlas_private_key

  client_shortname = var.client_shortname
  environment      = var.environment

  cluster_name  = "OpenEdX"
  region_name   = var.aws_region
  instance_size = var.mongodb_instance_size
  disk_size_gb  = var.mongodb_disk_size_gb

  mongodb_version              = var.mongodb_version
  num_shards                   = var.mongodb_num_shards
  replication_factor           = var.mongodb_replication_factor
  volume_type                  = var.mongodb_volume_type
  backup_enabled               = var.mongodb_backup_enabled
  auto_scaling_disk_gb_enabled = var.mongodb_auto_scaling_disk_gb_enabled
  auto_scaling_compute_enabled = var.mongodb_auto_scaling_compute_enabled
  auto_scaling_min_instances   = var.mongodb_auto_scaling_min_instance_size
  auto_scaling_max_instances   = var.mongodb_auto_scaling_max_instance_size
}
