# resource "aws_s3_bucket" "demo" {
#   count = 3

#   bucket = "terraform-learning-count-${count.index}-787308165643"

#   tags = {
#     Name = "count-demo-${count.index}"
#   }
# }

