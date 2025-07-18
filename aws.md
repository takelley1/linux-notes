## [AWS](https://docs.aws.amazon.com/)

## ALB (Application Load Balancer)

- Issue: Hitting the public URL of a service behind an ALB returns `502 Bad Gateway`
  - Cause: This is caused by a failing health check for all the target groups behind the ALB.
- Issue: Service behind ALB complains of an invalid HTTP request.
  - Cause: This is caused by the ALB using HTTP/2 and the service only supporting HTTP/1.

## EC2

### [Grow a volume](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html)

1. Resize the EBS volume such that `lsblk` shows the extra space.
2. Run `sudo growpart /dev/nvme0n1 1` to grow the LVM partition.
3. Run `sudo xfs_growfs /` to expand the filesystem into the LVM partition.

### [EKS](https://docs.aws.amazon.com/eks/?id=docs_gateway)

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
  <br><br>
  - [Updating EKS configmap for IAM user access:](https://aws.amazon.com/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/)
  ```bash
  kubectl edit configmap aws-auth -n kube-system
  ```
  ```yaml

  apiVersion: v1
  data:
    mapRoles: |
      - groups:
        - system:bootstrappers
        - system:nodes
        rolearn: arn:aws-us-gov:iam::123456789012:role/eks_gitlab_runner-eks-node-group-20220210182019868800000002
        username: system:node:{{EC2PrivateDNSName}}

    # Add mapUsers like so:
    mapUsers: |
      - userarn: arn:aws-us-gov:iam::123456789123:user/john.doe
        username: john.doe
        groups:
          - system:masters
      - userarn: arn:aws-us-gov:iam::098765432109:user/jane.doe
        username: jane.doe
        groups:
          - system:masters

  kind: ConfigMap
  metadata:
    creationTimestamp: "2022-02-10T17:14:57Z"
    name: aws-auth
    namespace: kube-system
    resourceVersion: "10432"
    uid: 19dc865b-2799-22b2-810a-6f10b19ea032
  ```
