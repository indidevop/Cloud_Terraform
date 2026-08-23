locals {
  environments_lst = ["dev","staging","prod"]

  environment_instances = {
    dev     = "t3.micro"
    staging = "t3.small"
    prod    = "t3.medium"
  }

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

locals {
  environment_names_map = {
    for env, instance_type in local.environment_instances : env => upper(env)
  }
}

output "environment_names_map" {
  value = local.environment_names_map
}
