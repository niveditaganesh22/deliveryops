provider "aws" {
  region = "us-east-1"
}
# trigger plan-dev
resource "aws_s3_bucket" "example" {
  bucket = "ng-deliveryops-dev-sandbox-${random_id.suffix.hex}"

  tags = {
    system  = "deliveryops-blueprint"
    env     = "dev"
    owner   = "nivedita"
    release = "apply-dev-smoke"
  }
}

resource "random_id" "suffix" {
  byte_length = 3
}
