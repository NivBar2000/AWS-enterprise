# AWS Enterprise Infrastructure Lab

Terraform infrastructure for an enterprise-style AWS environment with managed directory services, segmented networking, a private Windows management server and encrypted employee desktops.

**Personal infrastructure lab by Niv Bar.** This repository demonstrates infrastructure design and automation; it does not claim a currently running production environment.

## Architecture

- One DNS-enabled VPC with dedicated Active Directory and employee subnets across two availability zones.
- AWS Managed Microsoft AD Standard in the directory subnets.
- DHCP/DNS integration for directory-aware workloads.
- A private Windows Server 2022 EC2 management instance, with encrypted storage, required IMDSv2 and no public IP.
- Systems Manager associations for domain join, administrative tools and scripted directory configuration.
- Personal Amazon WorkSpaces for employees, with KMS-encrypted root/user volumes and a 60-minute auto-stop policy.

## Repository guide

| Files | Purpose |
| --- | --- |
| `main.tf`, `internet.tf`, `dhcp.tf` | VPC, subnet, routing, internet egress and directory DNS foundation |
| `directory.tf` | Managed Microsoft AD |
| `management.tf` | Private management host, scoped IAM and SSM automation |
| `organization.tf`, `scripts/` | Organization data and directory provisioning templates |
| `password.tf`, `secrets.tf`, `employee-secrets.tf` | Generated credentials and Secrets Manager resources |
| `workspaces.tf` | WorkSpaces directory, IAM, encryption and employee desktops |
| `variables.tf`, `providers.tf`, `outputs.tf` | Inputs, providers and infrastructure outputs |
| `docs/architecture/` | Architecture artifacts |

## Engineering focus

**Infrastructure as Code:** explicit dependencies connect networking, directory services, domain configuration and desktop creation.

**Identity and administration:** AWS manages the directory, while a separate private management host handles administrative configuration through Systems Manager.

**Desktop security:** employees are not local administrators by default. WorkSpaces use encrypted volumes and restrict self-service changes.

**Credential handling:** generated credentials are stored through Secrets Manager resources. Terraform state can contain secret values and must be treated as sensitive, even when outputs are marked sensitive. Never commit state, real variable files or credentials.

## Review and validate

Use an isolated AWS lab account and review the provider configuration, variables, organization data, PowerShell template and resource costs before provisioning.

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

These commands check configuration; they do not establish that resources are deployed. Initialization downloads providers. A reviewed `terraform plan` with the intended credentials and protected state is required before any apply.

Directory Service, NAT, EC2 and WorkSpaces can incur charges. Review backups and state carefully before teardown. This repository currently has no GitHub Actions workflow; provisioning is driven by Terraform and SSM configuration rather than an asserted CI/CD pipeline.
