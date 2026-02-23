# Architecture

DeliveryOps is a release governance layer built on:

- GitHub Actions (control plane)
- AWS OIDC federation
- Terraform remote state
- Environment isolation

---

## High-Level Flow


GitHub Workflow
↓
OIDC → AWS IAM Role
↓
Terraform Init (remote backend)
↓
Apply / Destroy
↓
State stored in S3
Locking via DynamoDB


---

## Remote State Strategy

State bucket:
`ng-deliveryops-tfstate-2026-ca`

State keys:

- Dev:
  deliveryops/dev/terraform.tfstate

- Stage:
  deliveryops/stage/terraform.tfstate

- Preview:
  deliveryops/preview/pr-<PR_NUMBER>.tfstate

Each environment has isolated state.
There is no shared state between environments.

---

## Preview Lifecycle

1. PR opened
   → Preview environment created
   → State key generated per PR

2. PR closed
   → Preview destroyed

3. TTL workflow scans for:
   - Closed PRs
   - Stale state beyond threshold

4. Manual TTL destroy cleans orphaned state

Schedule never destroys automatically.

---

## Security Model

- GitHub assumes AWS role via OIDC
- No static access keys
- IAM roles scoped per environment
- Stage protected with required reviewers

Trust boundary is explicitly defined:
GitHub identity → AWS role → Terraform execution.

---

## Design Goals

- Clear environment separation
- Predictable naming
- Lifecycle accountability
- Explicit destruction
- Cost hygiene

DeliveryOps acts as a reusable release controller.