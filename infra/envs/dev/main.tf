provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "ng-deliveryops-dev-sandbox-${random_id.suffix.hex}"

  tags = {
    system      = "deliveryops-blueprint"
    env         = "dev"
    lifecycle   = "sandbox"
    owner       = "nivedita"
    cost_center = "portfolio"
  }
}

resource "random_id" "suffix" {
  byte_length = 3
}
