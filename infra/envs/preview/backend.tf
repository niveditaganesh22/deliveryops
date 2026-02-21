terraform {
  backend "s3" {
    bucket         = "ng-deliveryops-tfstate-2026-ca"
    dynamodb_table = "ng-deliveryops-tf-locks"
    region         = "ca-central-1"
    encrypt        = true
    # key is injected at runtime by GitHub Actions:
    # -backend-config="key=deliveryops/preview/pr-123.tfstate"
  }
}
