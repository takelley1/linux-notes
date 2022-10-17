## Terraform

- **See also**:
  - [GitLab.com's internal Terraform workflows](https://gitlab.com/gitlab-com/gl-infra/readiness/-/tree/master/library/terraform-automation)

### Examples

- `terraform apply -target=module.eks` = Only apply the resources in the `eks` module.
- `terraform force-unlock -force e034e087-2961-9cc4-5e60-6d3508accd1a` = Forcibly unlock the remote state lock using a specific ID.
- `terraform state rm module.devops.module.gitlab.aws_acm_certificate.gitlab` = Remove a specific resource from the state file.
<br><br>
- `terraform console` = Launch REPL console for testing expressions.
  - `join(", ", [for value in aws_vpc.main : value.id])` = Try iterating over a map to create a string of values.
<br><br>
- `terraform refresh` = Add output to the state without running a fully `apply`.
- `terraform refresh -target=data.terraform_remote_state.main[\"eks\"]` = Pull in external remote state before running initial plan on imported resources
<br><br>
`terraform state list | sed 's/"/\\"/g' | xargs -n 1 terraform state rm` = Remove all resources in the state file.
