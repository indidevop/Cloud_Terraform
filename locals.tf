locals {
  project     = "terraform-learning"
  environment = "dev"

  common_tags = {
    Project     = "terraform-learning"
    Environment = "dev"
  }
}