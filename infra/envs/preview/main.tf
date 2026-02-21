provider "aws" {
  region = var.region
}

resource "random_id" "suffix" {
  byte_length = 3
}

resource "aws_s3_bucket" "example" {
  bucket = "ng-deliveryops-preview-pr-${var.pr_number}-${random_id.suffix.hex}"

  tags = {
    system  = "deliveryops-blueprint"
    env     = "preview"
    owner   = "nivedita"
    pr      = tostring(var.pr_number)
    ttl     = "48h"
    release = "preview"
    smoke   = "update-test"
  }
}
