locals {
  environments_lst = ["dev","staging","prod"]

  environment_names = [
        for env in local.environments_lst : upper(env)
    ]
  
}

output "environment_names" {
  value = local.environment_names
}