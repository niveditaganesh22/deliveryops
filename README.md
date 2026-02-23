# DeliveryOps Blueprint

A reusable, cost-aware release system for safely delivering cloud and data infrastructure.

DeliveryOps is built around one principle:  
infrastructure should have a clear lifecycle, and teardown discipline should be enforced — not optional.

It supports:

- PR preview environments (create on PR open, destroy on PR close)
- Gated promotions (dev → stage)
- Versioned releases with lifecycle tracking
- AWS OIDC authentication (no long-lived credentials)
- Terraform release discipline (`fmt` → `validate` → `plan` → `apply`)

This repository is designed to be **called from other repositories** using GitHub Actions reusable workflows.  
It acts as a centralized release layer rather than an application repository.

It is intentionally opinionated:
cost hygiene and teardown governance are non-negotiable.

---

## What Makes This Mine

### Delivery Ledger

Every environment action — preview creation, promotion, teardown — is treated as a lifecycle event.

Preview environments are not just created and forgotten.  
They are tracked, validated, and cleaned up.

TTL governance exists to prevent orphaned infrastructure.  
Destruction requires explicit confirmation.  
Scheduled workflows never destroy resources automatically.

The goal is predictability and accountability.

---

## Environment Model

**Dev**
- Auto-apply on push to `main`
- Isolated remote state
- Designed for continuous iteration

**Stage**
- Manual promotion
- Required reviewer gate
- Separate state and IAM role

**Preview**
- Created per pull request
- Isolated state key per PR
- Auto-destroy on PR close
- TTL-based cleanup for stale state

Each environment has strict state isolation and no shared Terraform backends.

---

## Security Model

- GitHub → AWS authentication via OIDC
- No static AWS access keys
- IAM roles scoped per environment
- Remote state stored in S3 with DynamoDB locking

Security and lifecycle are treated as first-class concerns.

---

## Lifecycle Governance

Preview environments follow this lifecycle:

1. PR opened → preview infra created
2. PR closed → preview infra destroyed
3. TTL workflow scans stale state (dry-run only)
4. Real cleanup requires manual confirmation

This ensures:
- No lingering infrastructure
- No silent destructive actions
- Clear operator intent

---

## Repo Layout

- `workflows/` — reusable GitHub Actions workflows (the product)
- `infra/bootstrap/` — OIDC + remote state bootstrap
- `infra/modules/` — opinionated Terraform wrappers (tags, TTL, preview env)
- `scripts/` — ledger + janitor utilities
- `docs/` — operational documentation

The workflows are the core deliverable.  
Infrastructure modules exist to enforce consistency and tagging discipline.

---

## Design Philosophy

- Environments must be isolated.
- State must never collide.
- Destruction must be intentional.
- Cost leakage is a bug.
- Governance should be automated but controlled.

DeliveryOps is not just CI/CD —  
it’s release discipline as code.

---

## Author

Nivedita Ganesh  
Cloud & Platform Automation  
AWS · Terraform · GitHub Actions
