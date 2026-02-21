variable "aws_region" {
  type        = string
  description = "AWS region for bootstrap resources"
  default     = "us-east-1"
}

variable "state_bucket_name" {
  type        = string
  description = "Globally-unique S3 bucket name for Terraform state"
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table name for Terraform state locking"
  default     = "terraform-state-locks"
}

variable "github_org" {
  type        = string
  description = "GitHub org/user that owns the repo"
}

variable "github_repo" {
  type        = string
  description = "GitHub repo name that will assume roles"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    system      = "deliveryops-blueprint"
    owner       = "nivedita"
    lifecycle   = "bootstrap"
    cost_center = "portfolio"
  }
}
