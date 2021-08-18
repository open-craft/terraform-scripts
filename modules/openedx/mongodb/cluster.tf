resource "mongodbatlas_cluster" "cluster" {
  project_id             = var.mongodbatlas_project_id
  name                   = local.cluster_name
  mongo_db_major_version = var.mongodb_version

  num_shards         = var.num_shards
  replication_factor = var.replication_factor

  auto_scaling_disk_gb_enabled                    = var.auto_scaling_disk_gb_enabled
  auto_scaling_compute_enabled                    = local.auto_scaling_compute_enabled
  auto_scaling_compute_scale_down_enabled         = local.auto_scaling_compute_enabled
  provider_auto_scaling_compute_min_instance_size = local.auto_scaling_min_instances
  provider_auto_scaling_compute_max_instance_size = local.auto_scaling_max_instances

  provider_name               = local.cloud_provider
  provider_region_name        = local.region_name
  disk_size_gb                = local.disk_size_gb
  provider_disk_iops          = local.disk_iops
  provider_volume_type        = local.volume_type
  cloud_backup                = var.backup_enabled
  encryption_at_rest_provider = local.encryption_at_rest_provider
  provider_instance_size_name = var.instance_size
}
