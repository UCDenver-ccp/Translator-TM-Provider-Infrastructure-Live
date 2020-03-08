# stage/terragrunt.hcl

# Note: much of this code borrowed from comment by marko7460 
#       in https://github.com/gruntwork-io/terragrunt/issues/780

remote_state {
  backend = "gcs"
  config = {
    skip_bucket_creation = true
    prefix               = "${path_relative_to_include()}"
    credentials          = "${find_in_parent_folders("credentials/terraform-credentials.json")}"
  }
}

# The backend-stage.tfvars file (referenced below) can be stored in the same directory
# as the credentials.json file. It should contain one line indicating the name
# of the bucket where terraform state is to be stored, 
# e.g. bucket = "terraform-state-prod"

terraform {
  extra_arguments "bucket" {
    commands  = ["init"]
    arguments = [
      "-backend-config=${find_in_parent_folders("credentials/backend-stage.tfvars")}",
    ]
  }
  extra_arguments "creds" {
    commands  = "${get_terraform_commands_that_need_vars()}"
    arguments = [
      "-var",
      "credentials=${find_in_parent_folders("credentials/terraform-credentials.json")}",
    ]
  }
  extra_arguments "common_vars" {
      commands = "${get_terraform_commands_that_need_vars()}"
      arguments = [
          "-var-file=${find_in_parent_folders("credentials/init.tfvars")}"
      ]
  }
  extra_arguments "backend_vars" {
      commands = "${get_terraform_commands_that_need_vars()}"
      arguments = [
          "-var-file=${find_in_parent_folders("credentials/init-stage.tfvars")}",
          "-var-file=${find_in_parent_folders("credentials/backend-stage.tfvars")}",
      ]
  }
}

inputs = {
  environment = "stage"
}

