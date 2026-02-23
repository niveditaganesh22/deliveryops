# Workflows
---

## apply-dev.yml

Trigger:
- Push to `main`

Behavior:
- OIDC authentication
- Terraform init (dev state key)
- Terraform apply

State:
deliveryops/dev/terraform.tfstate

Auto-apply. No manual approval.

---

## apply-stage.yml

Trigger:
- Manual dispatch

Behavior:
- OIDC authentication
- Terraform init (stage state key)
- Terraform apply

Protection:
- Requires reviewer approval
- Environment-scoped permissions

State:
deliveryops/stage/terraform.tfstate

---

## destroy-dev.yml

Trigger:
- Manual dispatch

Requires:
- Explicit confirmation input

Behavior:
- Terraform destroy
- State preserved unless explicitly removed

---

## destroy-stage.yml

Trigger:
- Manual dispatch

Requires:
- Explicit confirmation
- Approval gate

---

## preview-apply.yml

Trigger:
- Pull request (open, synchronize, reopen)

Behavior:
- Generates PR-specific state key
- Creates preview infrastructure
- Posts PR comment with details

State:
deliveryops/preview/pr-<PR_NUMBER>.tfstate

---

## preview-destroy.yml

Trigger:
- Pull request closed

Behavior:
- Terraform destroy
- Cleans preview infrastructure

---

## preview-ttl-cleanup.yml

Trigger:
- Scheduled (daily, dry-run only)
- Manual dispatch

Behavior:
- Scans preview state keys
- Identifies closed PRs older than TTL
- Dry-run by default
- Real destroy requires:
  confirm_destroy=true

Safety:
- Schedule cannot destroy
- Sequential execution
- Only preview keys eligible
