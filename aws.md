# AWS

## EKS

- **See also:**
  - [EKS creation tutorial](https://www.bluematador.com/blog/my-first-kubernetes-cluster-a-review-of-amazon-eks)
<br><br>
- Troubleshooting
  - [EKS unauthorized error](https://aws.amazon.com/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/)
  <br><br>
  - Ensure cluster endpoint has public access enabled.
  - Ensure `aws-iam-authenticator` is installed and at `$PATH`.
  <br><br>
  - Ensure the output of `aws sts get-caller-identity` prints the desired IAM profile. If AWS keys have been sourced for Terraform, this may print the Terraform IAM user. To change this to the `[default]` profile in your `~/.aws/credentials` file, launch a new shell.
  - `aws eks update-kubeconfig --region us-gov-west-1 --name my-cluster --profile terraform` = Create a kubeconfig file for the EKS cluster called *my-cluster* using the the *terraform* profile in the `~/.aws/credentials` file.
