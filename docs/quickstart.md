# Quickstart

This document explains how to use DeliveryOps from another repository.

DeliveryOps is designed to be called via GitHub Actions reusable workflows.
Your application repo does not need to copy Terraform logic — it calls this release system.

---

## Prerequisites

- AWS account with OIDC configured (via `infra/bootstrap/`)
- Remote state bucket + DynamoDB lock table
- IAM roles created for:
  - dev
  - stage
- Terraform 1.5+
- GitHub repository with permission to assume AWS role

No static AWS credentials are required.

---

## 1. Add Workflow in Your Application Repo

Create a workflow file in your app repository:

`.github/workflows/release.yml`

Example:

```yaml
name: Release

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  preview:
    if: github.event_name == 'pull_request'
    uses: niveditaganesh22/deliveryops/.github/workflows/preview-apply.yml@main
    with:
      working_directory: infra
      aws_region: us-east-1

  dev:
    if: github.event_name == 'push'
    uses: niveditaganesh22/deliveryops/.github/workflows/apply-dev.yml@main
    with:
      working_directory: infra
      aws_region: us-east-1
```
This delegates release control to DeliveryOps.

## 2. Required Inputs

Most workflows expect:

- working_directory

- aws_region

Preview workflows also automatically derive:

- PR number

- State key

- Preview resource naming

3. Promotion to Stage

Stage is manual by design.

Run:
```
apply-stage.yml
```
from GitHub Actions → Manual dispatch.

**Stage requires approval before execution.**

## 4. Destroy Behavior

Preview:

- Auto-destroy on PR close

- TTL scan runs daily (dry-run)

- Manual TTL destroy requires confirmation

Dev / Stage:

- Manual destroy workflows

- Explicit confirmation required

Destruction is never implicit.

## 5. What You Get

- Isolated remote state per environment

- Predictable naming

- Lifecycle tracking

- Guarded destructive operations

This blueprint enforces discipline across repositories.
