# Elasticsearch

AWS ElasticSearch Service, it's configured to allow full access but only from the specified AWS 
security group (should be supplied as Input), which should normally be specified as the security
group for the OpenedX instance.

## Input

- `customer_name`: the customer's name, this variable is used for resource naming
- `environment`: `prod` for example, this variable is used for resource naming
- `edxapp_security_group_id`: and AWS security group id, It should be the one configured for your OpenedX instance.
- `zone_awareness_enabled`: Indicates whether zone awareness is enabled in the ES domain. Defaults to `true`
- `availability_zone_count`: Used if `zone_awareness_enabled` is `true`, sets the number of Availability Zones
  to be used. Defaults to `2`
- `dedicated_master_enabled`: Indicates whether dedicated master nodes are enabled for the ES cluster. Defaults to `true`
- `instance_count`: Number of instances in the ES cluster. Defaults to `2`
- `start_subnets_index`: Start index for the subnets to be used by the ES domain, it's inclusive. Defaults to `0` 
- `end_subnets_index`: End index for the subnets to be used by the ES domain, it's exclusive. Defaults to `2`


## Output

- `elasticsearch`: to be set in the `ELASTICSEARCH_HOST` variable (without the `https`) part
