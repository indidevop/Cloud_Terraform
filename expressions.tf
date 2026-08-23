variable "environment" {
  type = string
    default = "prod"
}

locals {
    instance_type = var.environment == "prod" ? "t3.medium" : "t3.micro"
}

output "selected_instance_type" {
    value = local.instance_type
}