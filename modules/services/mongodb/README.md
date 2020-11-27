# MongoDB Cluster

If the client needs a customized MongoDB Cluster to be maintained by OpenCraft

> **IMPORTANT**: This isn't included in the normal maintenance plan we give to customers, so
> they should agree to this by a higher cost. We should push the customer to use MongoDB Atlas
> instead.

## Input

- `number_of_instances`: the number of instances belonging to this cluster
- `image_id`: The image ID to be used by the instances
- `instance_type`: The instance type to be used by the instances
- `customer_name`
- `environment`
- `edxapp_security_group_id`: AWS Security Group ID to access this instance (should be the one
specified for the edX instances)
- `openedx_key_pair_name`: The Key Pair name to ssh into this instances (from the instances in
the Security Group specified before)

## Output

- `mongodb_instances`: List of the Private IPs of the MongoDB instances (could be used for 
the `EDXAPP_MONGO_HOSTS` variable)

*Note*: You still need to configure a production-ready MongoDB service inside all of these instances,
specifying a ReplicaSet, Auth and SSL configuration 
