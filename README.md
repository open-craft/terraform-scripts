# terraform-scripts

This repository holds our common Terraform Open edX deployment scripts.

Currently it actually contains two different ways to provision AWS resources

## First Approach

Everything inside the `modules/openedx` folder.

### TODOS:

- Explanation of how to use these modules
- `rds` and `s3` modules should be merged into the `application` module
- Simplify configuration variables and remove *most deprecated settings* (check client requirements first)
- Rename `application` to `openedx` and move `wordpress` to outside of the openedx directory
- Automatically provision ACM certificates and domain names
- Move VPC creation from `private-repo` to `openedx` module

## Second Approach

Pretty basic way of provisioning, it contains the following modules:

- modules/email
- modules/route53
- modules/s3
- modules/services/director
- modules/services/elasticsearch
- modules/services/mongodb
- modules/services/openedx
- modules/services/sql
- modules/services/analytics

Please check each of those module folders to see what the module does.
For a simple AWS OpenedX provisioning, you could reuse these modules on the following way:

- One Terraform project with you'll only need to setup once (Route53, email):

      provider "aws" {
        region = <AWS Region>
        ...
      }

      module "route53" {
        source = "git@github.com:open-craft/terraform-scripts.git//modules/route53?ref=<LATEST RELEASE>"
      
        customer_domain = <CUSTOMER DOMAIN>
      }

      module "email" {
        source = "git@github.com:open-craft/terraform-scripts.git//modules/email?ref=<LATEST RELEASE>"
    
        customer_domain = <CUSTOMER DOMAIN>
        custom_emails_to_verify = <LIST OF EMAILS>
        internal_emails = <LIST OF INTERNAL EMAILS>
        route53_id = module.route53.route53_id
    
        customer_name = <CUSTOMER NAME>
        environment = <CUSTOMER ENVIRONMENT>
      }

- And another one for all the resources used in conjunction with the OpenedX instance:

      provider "aws" {
        region = "<AWS Region>"
        ...
      }
    
      module "director" {
        source = "git@github.com:open-craft/terraform-scripts.git//modules/services/director?ref=<LATEST RELEASE>"
        director_key_pair_name = <AWS DIRECTOR KEY PAIR NAME>
        image_id = <AWS DIRECTOR IMAGE ID>
        instance_type = <AWS DIRECTOR INSTANCE TYPE>
      }
    
      module "s3" {
        source = "git@github.com:open-craft/terraform-scripts.git//modules/s3?ref=<LATEST RELEASE>"
        customer_name = <CUSTOMER NAME>
        environment = <CUSTOMER ENVIRONMENT>
      }
    
      module "openedx" {
        source = "git@github.com:open-craft/terraform-scripts.git//modules/services/openedx?ref=<LATEST RELEASE>"    
        customer_name = <CUSTOMER NAME>
        director_security_group_id = module.director.director_security_group_id
        environment = <CUSTOMER ENVIRONMENT>
        customer_domain = <CUSTOMER DOMAIN>
      }
    
      module "sql" {
        source = "git@github.com:open-craft/terraform-scripts.git//modules/services/sql?ref=<LATEST RELEASE>"
    
        customer_name = <CUSTOMER NAME>
        environment = <CUSTOMER ENVIRONMENT>
    
        allocated_storage = <SQL ALLOCATED STORAGE>
        database_root_username = <SQL ROOT USERNAME>
        database_root_password = <SQL ROOT PASSWORD>
    
        edxapp_security_group_id = module.openedx.edxapp_security_group_id
    
        instance_class = <SQL INSTANCE CLASS>
      }
    
      module "elasticsearch" {
        source = "git@github.com:open-craft/terraform-scripts.git//modules/services/elasticsearch?ref=<LATEST RELEASE>"
        customer_name = <CUSTOMER NAME>
        edxapp_security_group_id = module.openedx.edxapp_security_group_id
        environment = <CUSTOMER ENVIRONMENT>
      }
    
      resource aws_instance edxapp {
        ami = <AWS EDX IMAGE ID>
        instance_type = <AWS EDX INSTANCE TYPE>
        vpc_security_group_ids = [module.openedx.edxapp_security_group_id]
    
        root_block_device {
          volume_size = 50        # setting only 50 GB for the edxapp disk space
          volume_type = "gp2"
        }
    
        key_name = <AWS EDX KEY PAIR NAME>
    
        tags = {
          Name = "edxapp-1"  # keep adding resources and change the name
        }
      }
    
      // adding the edx instance into the load balancer
      resource aws_lb_target_group_attachment edxapp {
        target_group_arn = module.openedx.edxapp_lb_target_group_arn
        target_id = aws_instance.edxapp.id
        port = 80
    
        lifecycle {
          create_before_destroy = true
        }
      }
    
      // adding the edx instance into the main domain load balancer
      resource aws_lb_target_group_attachment "edxapp_main_domain" {
        target_group_arn = module.openedx.edxapp_main_domain_lb_target_group_arn
        target_id = aws_instance.edxapp.id
        port = 80
      }
      

For more information on how to deploy an OpenedX instance with Terraform, please go
to our internal [AWS terraform deployment tutorial](https://gitlab.com/opencraft/documentation/public/-/blob/master/tutorials/howtos/aws/AWS_terraform_deployment_tutorial.md)
