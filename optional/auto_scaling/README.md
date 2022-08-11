# AWS Auto Scaling Group module

This configures a new Launch Template and Auto Scaling group and adds the latter to the existing load balancer.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ami_from_instance.images](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami_from_instance) | resource |
| [aws_autoscaling_group.edxapp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.target_tracking](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_launch_template.edxapp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_subnets.subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_scaling_desired_capacity"></a> [auto\_scaling\_desired\_capacity](#input\_auto\_scaling\_desired\_capacity) | Set this if you want to immediately override a number of existing instances. | `number` | `null` | no |
| <a name="input_auto_scaling_instance_type"></a> [auto\_scaling\_instance\_type](#input\_auto\_scaling\_instance\_type) | The type of the EC2 instance. | `string` | `"t3.xlarge"` | no |
| <a name="input_auto_scaling_max_instances"></a> [auto\_scaling\_max\_instances](#input\_auto\_scaling\_max\_instances) | The maximum size of the Auto Scaling Group. | `number` | `4` | no |
| <a name="input_auto_scaling_min_instances"></a> [auto\_scaling\_min\_instances](#input\_auto\_scaling\_min\_instances) | The minimum size of the Auto Scaling Group. | `number` | `2` | no |
| <a name="input_aws_vpc_id"></a> [aws\_vpc\_id](#input\_aws\_vpc\_id) | The ID of the AWS VPC that should contain all of the resources. | `string` | n/a | yes |
| <a name="input_client_shortname"></a> [client\_shortname](#input\_client\_shortname) | A short tag name for the client that will be used in naming resources. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name for this deployment (e.g. stage, prod). | `string` | n/a | yes |
| <a name="input_instances"></a> [instances](#input\_instances) | The list of existing "source" EC2 instances. The AMIs will be created from each of them if they don't exist yet.<br>**Note 1**: existing AMIs cannot be imported into the Terraform state. They will need to be recreated.<br>**Note 2**: instances will be stopped before taking the snapshots and then started back up again, resulting in a period of downtime. | <pre>list(object({<br>    id   = string<br>    tags = object({<br>      Name = string<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | You can use a key pair to securely connect to your instance. | `string` | `"appserver"` | no |
| <a name="input_lb_target_group_arn"></a> [lb\_target\_group\_arn](#input\_lb\_target\_group\_arn) | The target group to which the Auto Scaling group will be attached. | `string` | n/a | yes |
| <a name="input_release"></a> [release](#input\_release) | The name of the Open edX Release. | `string` | n/a | yes |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | The ID of the security group that should be used for creating resources in Auto Scaling group. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
