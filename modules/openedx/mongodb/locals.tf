locals {
  // Values used for computations below
  _mongodb_instance_size_split = split("_", var.instance_size)

  /********** Start MongoDB Variable Computations **********/

  cloud_provider = "AWS"

  // Compute MongoDB cluster name
  cluster_name = lower(join("-", [var.client_shortname, var.cluster_name, var.environment]))

  // Compute appropriate disk_size_gb value
  disk_size_gb = (
    // If null, keep null
    var.disk_size_gb == null ?
    var.disk_size_gb :
    (
      // Disallow on NVMe clusters
      length(local._mongodb_instance_size_split) > 1 &&
      element(local._mongodb_instance_size_split, 1) == "NVME" ?
      null :
      // Value must be 10 <= disk_size_gb <= 4096
      max(min(var.disk_size_gb, 4096), 10)
    )
  )

  // Compute value for region_name from region
  region_name = upper(replace(var.region_name, "-", "_"))

  // Compute appropriate value for disk_iops
  disk_iops = (
    // If null, keep null
    var.disk_iops == null ?
    var.disk_iops :
    (
      // Disallow on NVMe clusters
      length(local._mongodb_instance_size_split) > 1 &&
      element(local._mongodb_instance_size_split, 1) == "NVME" ?
      null :
      var.disk_iops
    )
  )

  // Compute value for volume_type based disk_iops
  volume_type = (
    // Disallow on NVMe clusters
    length(local._mongodb_instance_size_split) > 1 &&
    element(local._mongodb_instance_size_split, 1) == "NVME" &&
    var.disk_iops != null ?
    // Override if using a non-default value
    "PROVISIONED" :
    //Otherwise set to desired value, using "STANDARD" as
    //  default when nothing is provided
    (
      var.volume_type == null ?
      "STANDARD" :
      var.volume_type
    )
  )

  // Compute whether encryption at rest is possible given the instance size
  encryption_at_rest_provider = (
    (
      // If we want encryption at rest, and the instance size is M10 or greater
      var.encryption_at_rest &&
      tonumber(
        // Discard first character, and compare the number to 10
        substr(
          local._mongodb_instance_size_split[0],
          1,
          length(local._mongodb_instance_size_split[0]) - 1
        )
      ) >= 10
    ) ?
    // Set the provider to that value
    upper(local.cloud_provider) :
    // Otherwise, set the value to NONE
    "NONE"
  )

  // Compute whether compute-based autoscaling is enabled,
  // and what max and min instance values should be
  auto_scaling_compute_enabled = (
    var.auto_scaling_compute_enabled &&
    var.auto_scaling_min_instances != null &&
    var.auto_scaling_max_instances != null
  )
  auto_scaling_min_instances = (
    var.auto_scaling_compute_enabled &&
    var.auto_scaling_min_instances != null &&
    var.auto_scaling_max_instances != null ?
    var.auto_scaling_min_instances :
    null
  )
  auto_scaling_max_instances = (
    var.auto_scaling_compute_enabled &&
    var.auto_scaling_min_instances != null &&
    var.auto_scaling_max_instances != null ?
    var.auto_scaling_max_instances :
    null
  )
  /********** End MongoDB Variable Computations **********/
}
