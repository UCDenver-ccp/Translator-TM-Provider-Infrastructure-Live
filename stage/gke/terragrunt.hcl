# stage/gke/terragrunt.hcl

# import the backend configuration which 
# is specified in the parent folder
include {
    path = "${find_in_parent_folders()}"
}

terraform {
    source = "github.com/UCDenver-ccp/Translator-TM-Provider-Infrastructure-Modules.git//gke?ref=v0.1.0"
}

#inputs = {
#    instance_count = 3
#    instance_type = "XXX"
#}