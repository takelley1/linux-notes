# AWS

## EKS

- `aws sts get-caller-identity` = Print the AWS IAM profile that's being used. If AWS keys have been sourced for Terraform, this may print the Terraform IAM user. To change this to the `[default]` profile in your `~/.aws/credentials` file, launch a new shell.
