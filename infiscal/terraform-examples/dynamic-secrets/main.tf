terraform {
  required_version = ">= 1.10.0"
  
  required_providers {
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.15"
    }
  }
}

provider "infisical" {
  host = var.infisical_host
  auth = {
    universal = {
      client_id     = var.infisical_client_id
      client_secret = var.infisical_client_secret
    }
  }
}