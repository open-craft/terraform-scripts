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

## Output

- `mysql_host_name`: MySQL instance Endpoint. To be set in the `EDXAPP_MYSQL_HOST` variable
