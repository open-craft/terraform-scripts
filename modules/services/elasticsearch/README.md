# Elasticsearch

AWS ElasticSearch Service, it's configured to allow full access but only from the specified AWS 
security group (should be supplied as Input), which should normally be specified as the security
group for the OpenedX instance.

## Input

- `customer_name`: the customer's name, this variable is used for resource naming
- `environment`: `prod` for example, this variable is used for resource naming
- `edxapp_security_group_id`: and AWS security group id, It should be the one configured for your
OpenedX instance.

## Output

- `elasticsearch`: to be set in the `ELASTICSEARCH_HOST` variable (without the `https`) part
