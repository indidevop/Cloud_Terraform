locals {
  environments_lst = ["dev","staging","prod"]

  environment_names = [
        for env in local.environments_lst : upper(env)
    ]

    nonprod_environments = [
        for env in local.environments_lst : env if env != "prod"
    ]
  
}

output "environment_names" {
  value = local.environment_names
}

output "nonprod"{
   value = local.nonprod_environments
}  
