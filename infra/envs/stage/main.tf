provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 3
}

resource "aws_s3_bucket" "example" {
  bucket = "ng-deliveryops-stage-sandbox-${random_id.suffix.hex}"

  tags = {
    system      = "deliveryops-blueprint"
    env         = "stage"
    lifecycle   = "sandbox"
    owner       = "nivedita"
    cost_center = "portfolio"
  }
}
