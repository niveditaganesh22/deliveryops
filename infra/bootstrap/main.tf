locals {
  repo_full = "${var.github_org}/${var.github_repo}"
}

# -----------------------------
# 1) Terraform remote state
# -----------------------------
resource "aws_s3_bucket" "tf_state" {
  bucket = var.state_bucket_name

  tags = merge(var.tags, {
    name = var.state_bucket_name
    type = "terraform-state"
  })
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.tags, {
    name = var.lock_table_name
    type = "terraform-locks"
  })
}

# -----------------------------
# 2) GitHub OIDC provider
# -----------------------------
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]

  tags = merge(var.tags, { type = "oidc-provider" })
}

# -----------------------------
# 3) IAM Roles (dev + stage)
# -----------------------------
data "aws_iam_policy_document" "github_assume_role_base" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${local.repo_full}:*"]
    }
  }
}

resource "aws_iam_role" "deliveryops_dev" {
  name               = "deliveryops-dev"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role_base.json
  tags               = merge(var.tags, { env = "dev" })
}

resource "aws_iam_role" "deliveryops_stage" {
  name               = "deliveryops-stage"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role_base.json
  tags               = merge(var.tags, { env = "stage" })
}

# Broad for now (we’ll tighten after preview env works)
data "aws_iam_policy_document" "terraform_minimum" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "dynamodb:*",
      "iam:*",
      "lambda:*",
      "logs:*",
      "apigateway:*",
      "sqs:*",
      "events:*",
      "cloudwatch:*",
      "ec2:Describe*",
      "sts:GetCallerIdentity"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_minimum" {
  name   = "deliveryops-terraform-minimum"
  policy = data.aws_iam_policy_document.terraform_minimum.json
}

resource "aws_iam_role_policy_attachment" "dev_attach" {
  role       = aws_iam_role.deliveryops_dev.name
  policy_arn = aws_iam_policy.terraform_minimum.arn
}

resource "aws_iam_role_policy_attachment" "stage_attach" {
  role       = aws_iam_role.deliveryops_stage.name
  policy_arn = aws_iam_policy.terraform_minimum.arn
}
