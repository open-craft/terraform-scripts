# AWS RDS

OpenedX needs MySQL, so we configure AWS RDS. We are configuring it be accessible only from an
AWS Security Group

## Input

- `customer_name`
- `environment`
- `instance_class`: Class to be used by the RDS instance (like Instance Type)
- `allocated_storage`: size of the instance allocated storage (in GB)
- `database_root_username`: Root username, we normally set this to `opencraft`. To be set in the
`EDXAPP_MYSQL_USER` variable
- `database_root_password`: Root password. To be set in the `EDXAPP_MYSQL_PASSWORD` variable
- `edxapp_security_group_id`: Security Group ID of the edX instance
- `max_allocated_storage`: Default to 100, this also enables autoscaling, set it to 0 to disable
- `extra_security_group_ids`: List of Security Group IDs to add to the main RDS instance
- `number_of_replicas`: Sets the number of replicas, defaults to `0`
- `replica_extra_security_group_ids`: List of extra Security Group IDs to add only to the RDS instance replicas.
  The main RDS instance Security Group IDs are always added to the replicas
- `replica_publicly_accessible`: Sets the replica instances to be public, defaults to `false`
- `enable_replica_multi_az`: Sets if the replicas should be enabled in multiple Availability Zones, defaults to `false`

## Output

- `mysql_host_name`: MySQL instance Endpoint. To be set in the `EDXAPP_MYSQL_HOST` variable
