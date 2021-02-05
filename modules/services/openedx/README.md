# OpenedX Instance Setup

This terraform module doesn't actually configure or even creates an OpenedX instance (AWS EC2
instance), but it setups everything the AWS Instance needs for you to just plugin the instance
on your own terraform script.

So basically you can use this module, but you also need to create the instance, and add that 
instance into the load balancers (that this module will create) on your own. It should look like this:

    resource aws_instance edxapp {
      ami = <Image ID>
      instance_type = <Instance Type>
      vpc_security_group_ids = [module.openedx.edxapp_security_group_id]
    
      root_block_device {
        volume_size = 50        # setting only 50 GB for the edxapp disk space
        volume_type = "gp2"
      }
    
      key_name = <OpenedX Instance Key Pair Name>
      user_data = file("scripts/setup_edx_instance.sh") # check the setup_edx_instance.sh.example
                                                        # for what the instance needs installed
    
      tags = {
        Name = "edxapp-<NUMBER>"  # keep adding resources and change the name
      }
    }
    
This is necessary because we still do the spawn of new instances manually, setting the <NUMBER>
manually indicating the times we've deployed a new instance for this client.

You also need to add the instance into the already configured load balancer. We are actually
creating two load balancers, one that points to all subdomains, and another one for the root domain.
We do this because of the SSL certificates we issue (one for the root domain and one for all 
subdomains), we have to configure a Route53 record for each and then connect one load balancer to
each of those records. Here the examples of how to add this instance into the load balancers:

    resource aws_lb_target_group_attachment edxapp {
      target_group_arn = module.openedx.edxapp_lb_target_group_arn
      target_id = aws_instance.edxapp.id
      port = 80
    
      lifecycle {
        create_before_destroy = true
      }
    }
    
    resource aws_lb_target_group_attachment "edxapp_main_domain" {
      target_group_arn = module.openedx.edxapp_main_domain_lb_target_group_arn
      target_id = aws_instance.edxapp.id
      port = 80
    }

You'll have to create the previous 3 resources every time you want to deploy a new OpenedX instance
(for example every time you do a release update, bug fix, etc.).

## Assumptions

- A Route53 hosted zone has been created and its respective ACM Certificates have been issued.(check 
the `route53` module)
- 

## Resources

This module creates the following resources:

- 2 **Application Load Balancer** (one for subdomains and one for the main domain) with its 
respective security groups and listeneres
- A **Security Group** for the OpenedX instance
- All the necessary **Route 53 records** for the edX subdomains

## Input

- `customer_domain`: It should also match the Route53 configured domain
- `customer_name`
- `environment`
- `director_security_group_id`: The director's security group ID (check the `director` module)
- `route53_subdomains`: Subdomains to add as route53 records pointing to the Load Balancer
- `lb_idle_timeout`: Load Balancer idle timeout
- `enable_https`: If your ACM is not issued just yet or you don't need https, set this to `false`  
- `lb_ssl_security_policy`: The predefined AWS ssl policy to be used by the load balancer. Defaults to "ELBSecurityPolicy-2016-08"
