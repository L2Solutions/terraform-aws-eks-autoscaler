terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 0.15"

  experiments = [module_variable_optional_attrs]
}