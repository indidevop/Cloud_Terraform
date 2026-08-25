# Building AWS Infra using Terraform

<!-- Add your AWS architecture diagram as `aws-architecture.png` in the repo, or update the path below -->
![AWS Architecture Diagram](./aws_terraform)
*AWS architecture diagram — add or replace `aws-architecture.png` with your diagram.*

A simple, incremental Terraform example repository that builds a small AWS environment (VPC, subnets, IGW, route tables, EC2 with key pair and security group) using modules and demonstrates moving state to an S3 backend. This README explains the repo structure, how the project evolved (with links to the commits), and step-by-step commands so you can learn Terraform by reading and running the code.

Table of Contents
- About this repo
- Learning goals & recommended order
- Repo structure
- Key commits (use these to follow the project history)
- Quick start (prerequisites + run commands)
- Backend and state (S3) — migration notes
- How modules were introduced (explain progression)
- Useful Terraform tips & learning resources
- Contributing & cleanup

---

About this repo
This repository demonstrates building AWS infrastructure with Terraform. The project was built incrementally — each commit adds a small piece (provider, VPC, subnets, IGW, route tables, EC2, key pair, security group) or refactors resources into modules. Use the commit links below to study each change and learn typical Terraform patterns.

Learning goals & recommended order
1. Read the initial commit history and provider configuration to learn how the project starts. See "Add provider" (commit).
2. Learn how resources are created: VPC → subnets → IGW → route tables → EC2, SG, key pair.
3. See how variables, outputs, and data blocks are used and why they matter.
4. Learn how to modularize Terraform by following commits that migrate resources into modules.
5. Learn about state management and migrating state to an S3 backend.

If you are new to Terraform, follow these steps in this order to learn effectively:
- Inspect the provider commit and basic resources.
- Run `terraform init`, `terraform plan`, `terraform apply` in a safe test AWS account.
- Follow later commits that modularize the infra to see best practices for reuse.

Repo structure
- modules/
  - vpc/            (VPC module introduced in commit "Added VPC as module")
  - public_subnet/  (public subnet module)
  - private_subnet/ (private subnet module)
  - igw/            (Internet Gateway module)
  - route_table/    (Public route table & association module)
  - ec2/            (EC2 instance, security group, key pair module)
- main.tf / root modules and top-level configuration
- variables.tf
- outputs.tf
- .gitignore

Key commits (follow these to learn the project's progression)
- Add provider — https://github.com/indidevop/Cloud_Terraform/commit/3fa0f1a802c61087db7df7895c6d376ab586e37f
  - The starting point: provider configuration and initial Terraform setup.
- Building AWS infra using terraform — https://github.com/indidevop/Cloud_Terraform/commit/a00741bb70c3ceb966503452167891f8ad578553
  - First higher-level commit indicating the repository's purpose.
- Added VPC, public and private subnets — https://github.com/indidevop/Cloud_Terraform/commit/a9d84e60525bfa7f497bfa8efbd98eb9b11600cd
  - Introduces the VPC and both subnet types.
- Added IGW — https://github.com/indidevop/Cloud_Terraform/commit/816852b71b59a39a881a63efbe3e3ff4cf58b40f
  - Adds the Internet Gateway to enable internet access for public subnets.
- Added public route table — https://github.com/indidevop/Cloud_Terraform/commit/282df4c16aa878f1ee8c8d640ccab99d18ff3877
  - Adds route table for public subnets; important for routing to the IGW.
- Created sg for ec2 — https://github.com/indidevop/Cloud_Terraform/commit/cd93eede02dec61ae48af396ca0a39ac8150d35b
  - Security group rules for EC2 instances.
- Created ec2 — https://github.com/indidevop/Cloud_Terraform/commit/964068d4815c8ab57bc5302e041fdd1837b00cc8
  - EC2 instance creation and associated resources.
- Added key pair to ec2 — https://github.com/indidevop/Cloud_Terraform/commit/e6afd9d289932f2a9bd4c9db1dc5adcab1ebcf94
  - Adds key pair resource used for access to EC2.
- Added variables file — https://github.com/indidevop/Cloud_Terraform/commit/cf92eedb753e394c9f7e6ceb0e73e84b7f6895af
  - Introduces variables to parametrize the configuration.
- Added variables and outputs file — https://github.com/indidevop/Cloud_Terraform/commit/ee89c8f1eb64a6a763490e2ad488518ac51d2b69
  - Adds outputs to expose key information after apply.
- Added data block — https://github.com/indidevop/Cloud_Terraform/commit/030d5db5c4842039009e86e89cde6c6352c06f9c
  - Uses data blocks (e.g., to read AMI info or existing resources).
- Ignore Terraform generated files (.gitignore) — https://github.com/indidevop/Cloud_Terraform/commit/1c345adb746f216b0528b11888c2d55eb51c4492
  - Ensures local state and generated files are not committed.
- Added VPC as module — https://github.com/indidevop/Cloud_Terraform/commit/07d7ec4ad3446cb26739ef25c3cafefc0c1f7e4a
  - Starts modularizing the VPC.
- Added public subnet as module — https://github.com/indidevop/Cloud_Terraform/commit/e7cb3560d1ebf15f319e6a8c13c920c227ff8edf
  - Moves public subnet to its own module.
- Migrated private subnet to module — https://github.com/indidevop/Cloud_Terraform/commit/2b582abc32be21d24639221f08196db6270fb524
  - Moves private subnet to module.
- Migrated IGW to module — https://github.com/indidevop/Cloud_Terraform/commit/c37c36ab7585bc522aa710bfe85523f102fdde63
  - IGW moved to module for reuse/clarity.
- Migrated public route table to module — https://github.com/indidevop/Cloud_Terraform/commit/90160a3c6cd532003a9d9fcc6be947d191b1ad4e
  - Route table moved into a module.
- Migrated public route table association to module — https://github.com/indidevop/Cloud_Terraform/commit/7481eb19aa704918ff6b55ca3cfd1434a5451f10
  - Route table association moved to module.
- Created S3 bucket using cli and added its info in the backend block, then init -reconfigure to migrate state to S3. — https://github.com/indidevop/Cloud_Terraform/commit/3d2da200ba91d150beff9fb57754647ad3906c3d
  - Shows how the repo migrated Terraform state to an S3 backend (state management example).

Quick start

Prerequisites
- Terraform (v1.0+ recommended). Check with `terraform version`.
- AWS CLI configured (credentials + region) or environment variables set (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION).
- A non-production AWS account for testing.

Clone the repo:
git clone https://github.com/indidevop/Cloud_Terraform.git
cd Cloud_Terraform

Initialize and use the S3 backend (if you've added the backend bucket)
- This repo includes an S3 backend migration in commit [3d2da20]. If the backend is configured, run:
  terraform init
  # If you need to reconfigure the backend (moved state to S3):
  terraform init -reconfigure
  # To inspect the plan:
  terraform plan -var-file="terraform.tfvars"
  terraform apply -var-file="terraform.tfvars"

If the S3 backend is not yet available in your AWS account, remove or comment the backend block from `main.tf` temporarily and run:
  terraform init
  terraform plan
  terraform apply

State and backend notes (S3)
- The project demonstrates migrating state to S3 in commit [3d2da200](https://github.com/indidevop/Cloud_Terraform/commit/3d2da200ba91d150beff9fb57754647ad3906c3d).
- Typical backend configuration (example — check your repo's backend block):
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "cloud_terraform/terraform.tfstate"
    region = "us-east-1"
  }
- Use `terraform init -reconfigure` when switching or migrating backends, and always lock state when multiple collaborators may run terraform at once (enable DynamoDB state locking if needed).

How modules were introduced (progression to study)
- The project begins with flat resource definitions (VPC, subnets, IGW, route tables) introduced in earlier commits (see commits between 2026-08-19 and 2026-08-21).
- Later commits progressively move resources into modules to improve reuse:
  - VPC module: https://github.com/indidevop/Cloud_Terraform/commit/07d7ec4ad3446cb26739ef25c3cafefc0c1f7e4a
  - Public & private subnet modules: https://github.com/indidevop/Cloud_Terraform/commit/e7cb3560d1ebf15f319e6a8c13c920c227ff8edf and https://github.com/indidevop/Cloud_Terraform/commit/2b582abc32be21d24639221f08196db6270fb524
  - IGW & route table modularization: https://github.com/indidevop/Cloud_Terraform/commit/c37c36ab7585bc522aa710bfe85523f102fdde63 and https://github.com/indidevop/Cloud_Terraform/commit/90160a3c6cd532003a9d9fcc6be947d191b1ad4e

Learning tips & recommended reading
- Read commits in chronological order to see how the author builds and then refactors the infra.
- Look at how variables and outputs were added (commits: https://github.com/indidevop/Cloud_Terraform/commit/cf92eedb753e394c9f7e6ceb0e73e84b7f6895af and https://github.com/indidevop/Cloud_Terraform/commit/ee89c8f1eb64a6a763490e2ad488518ac51d2b69).
- Inspect the data block usage for real examples of looking up existing resources or AMIs: https://github.com/indidevop/Cloud_Terraform/commit/030d5db5c4842039009e86e89cde6c6352c06f9c
- When you run code, try toggling variable values and re-running `terraform plan` to see incremental changes.

Commands cheat sheet
- terraform init
- terraform plan -var-file="terraform.tfvars"
- terraform apply -var-file="terraform.tfvars"
- terraform destroy -var-file="terraform.tfvars"
- terraform fmt
- terraform validate
- terraform state list
- terraform init -reconfigure (when migrating backends)

Contributing
- Use branches for changes and open PRs.
- Don't commit `.tfstate` or `.terraform/` — see commit that added .gitignore: https://github.com/indidevop/Cloud_Terraform/commit/1c345adb746f216b0528b11888c2d55eb51c4492

Cleaning up (important)
- After testing, run `terraform destroy -var-file="terraform.tfvars"` to remove resources to avoid AWS charges.
- Make sure to delete the S3 state bucket if you created one only for testing (and its DynamoDB lock table if used).

Reference commit timeline (short)
- a00741b — Building AWS infra using terraform — https://github.com/indidevop/Cloud_Terraform/commit/a00741bb70c3ceb966503452167891f8ad578553
- 3fa0f1a — Add provider — https://github.com/indidevop/Cloud_Terraform/commit/3fa0f1a802c61087db7df7895c6d376ab586e37f
- a9d84e6 — Added VPC, public and private subnets — https://github.com/indidevop/Cloud_Terraform/commit/a9d84e60525bfa7f497bfa8efbd98eb9b11600cd
- 816852b — Added IGW — https://github.com/indidevop/Cloud_Terraform/commit/816852b71b59a39a881a63efbe3e3ff4cf58b40f
- 282df4c — Added public route table — https://github.com/indidevop/Cloud_Terraform/commit/282df4c16aa878f1ee8c8d640ccab99d18ff3877
- cd93eed — Created sg for ec2 — https://github.com/indidevop/Cloud_Terraform/commit/cd93eede02dec61ae48af396ca0a39ac8150d35b
- 964068d — Created ec2 — https://github.com/indidevop/Cloud_Terraform/commit/964068d4815c8ab57bc5302e041fdd1837b00cc8
- e6afd9d — Added key pair to ec2 — https://github.com/indidevop/Cloud_Terraform/commit/e6afd9d289932f2a9bd4c9db1dc5adcab1ebcf94
- cf92eed — Added variables file — https://github.com/indidevop/Cloud_Terraform/commit/cf92eedb753e394c9f7e6ceb0e73e84b7f6895af
- ee89c8f — Added variables and outputs file — https://github.com/indidevop/Cloud_Terraform/commit/ee89c8f1eb64a6a763490e2ad488518ac51d2b69
- 030d5db — Added data block — https://github.com/indidevop/Cloud_Terraform/commit/030d5db5c4842039009e86e89cde6c6352c06f9c
- 07d7ec4 — Added VPC as module — https://github.com/indidevop/Cloud_Terraform/commit/07d7ec4ad3446cb26739ef25c3cafefc0c1f7e4a
- e7cb356 — Added public subnet as module — https://github.com/indidevop/Cloud_Terraform/commit/e7cb3560d1ebf15f319e6a8c13c920c227ff8edf
- 2b582ab — Migrated private subnet to module — https://github.com/indidevop/Cloud_Terraform/commit/2b582abc32be21d24639221f08196db6270fb524
- c37c36a — Migrated IGW to module — https://github.com/indidevop/Cloud_Terraform/commit/c37c36ab7585bc522aa710bfe85523f102fdde63
- 90160a3 — Migrated public route table to module — https://github.com/indidevop/Cloud_Terraform/commit/90160a3c6cd532003a9d9fcc6be947d191b1ad4e
- 7481eb1 — Migrated public route table association to module — https://github.com/indidevop/Cloud_Terraform/commit/7481eb19aa704918ff6b55ca3cfd1434a5451f10
- 3d2da20 — Created S3 bucket using cli and added its info in the backend block, then init -reconfigure to migrate state to S3 — https://github.com/indidevop/Cloud_Terraform/commit/3d2da200ba91d150beff9fb57754647ad3906c3d

Further help / learning resources
- Terraform docs: https://www.terraform.io/docs
- AWS provider docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- State and backends: https://www.terraform.io/language/state

---

If you want, I can:
- Commit this README to your repo.
- Add inline code snippets extracted from current files (e.g., actual backend block, sample module call) referencing the precise file lines or commits.
- Create a sample terraform.tfvars.example and a checklist for safe testing (IAM least-privilege, cost estimate).
