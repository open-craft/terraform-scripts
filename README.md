# terraform-scripts

This repository holds our common Terraform Open edX deployment scripts.

## TODOS:

- `rds` and `s3` modules should be merged into the `application` module
- Simplify configuration variables and remove *most deprecated settings* (check client requirements first)
- Rename `application` to `openedx` and move `wordpress` to outside of the openedx directory
- Automatically provision ACM certificates and domain names
- Move VPC creation from `private-repo` to `openedx` module
