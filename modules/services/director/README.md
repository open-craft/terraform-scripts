# The Director Instance

For installation of OpenedX, we use this one as a secondary instance. OpenedX instance access should
be done through the director, so this instance comes with everything configured (in terms of access)
so the OpenedX instance can be reachable from the outside.

The OpenedX instance shouldn't even be accessible through SSH from the public, only the director is
able to access it (and we are the only ones with access to the director).

## Assumptions

- You've created/imported a "Key Pair" in AWS (it can be done through the console) and you have the
public and private keys. They will be used for SSH access into the director instance. 

*Note*: You should actually create two (one for the director and one for the edX instances)

## Input

You should get the following variables from AWS Console, with what's available
for the region you are going to use:

- `image_id`: AWS Image ID for this instance (e.g. ami-0edab4XXXXXXXXX)
- `instance_type`: Instance type, we recommend to use the smallest one (e.g. `t2.micro`)
- `director_key_pair_name`: Name you given to the AWS Key Pair to be used to ssh into the director
- `ebs_volume_type`: Type of EBS volumes attached to the instance. Defaults to "gp2".
- `ebs_volume_size`: Size of EBS volumes attached to the instance (in GiB). Defaults to 8.
- `ebs_iops`: Baseline input/output (I/O) performance of EBS volumes attached to the instance. Applicable only if `ebs_volume_type` is set to "gp3". Defaults to 3000.

## Output

- `director_public_ip`: Informative, just so you know what instance to ssh into

*Note*: To ssh into this instance you'll do something like:

    ssh -i director.pem <user>@<director_public_ip>
    
To get the right command, you should go into the AWS console, select the director EC2 instance and 
check how to "Connect" to it (for Ubuntu instances, the `<user>` is `ubuntu`)
