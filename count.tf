# resource "aws_s3_bucket" "demo" {
#   count = 3

#   bucket = "terraform-learning-count-${count.index}-787308165643"

#   tags = {
#     Name = "count-demo-${count.index}"
#   }
# }

locals {
  environments = toset([
    "dev",
    "staging",
    "prod"
  ])
}

resource "aws_s3_bucket" "demo" {
  for_each = local.environments

  bucket = "terraform-learning-${each.key}-787308165643"

  tags = {
    Name        = "terraform-learning-${each.key}"
    Environment = each.key
  }
}