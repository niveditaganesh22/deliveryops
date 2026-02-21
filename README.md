# DeliveryOps Blueprint

A reusable, cost-aware release system for safely delivering cloud and data systems:
- PR preview environments (create on PR, destroy on close)
- gated promotions (dev → stage)
- versioned releases + lifecycle tracking
- AWS OIDC (no long-lived keys)
- Terraform release discipline (fmt/validate/plan/apply)

This repo is designed to be **called** from other repos via GitHub Actions reusable workflows.
It is intentionally opinionated: cost hygiene and teardown discipline are non-negotiable.

## What makes this mine
Delivery Ledger: every environment action (preview/prod promotion/teardown) is tracked as an auditable lifecycle record.

## Repo layout
- `workflows/` — reusable GitHub Actions workflows (the product)
- `infra/bootstrap/` — OIDC + remote state bootstrap
- `infra/modules/` — opinionated wrappers (tags, TTL, preview env)
- `scripts/` — ledger + janitor utilities
- `docs/` — human docs with operational tone