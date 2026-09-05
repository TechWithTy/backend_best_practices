terraform {
  required_version = ">= 1.10.0"
  
  required_providers {
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.15"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
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

# Create your project
resource "infisical_project" "main" {
  name = var.project_name
  slug = var.project_slug
}

# Create environments
locals {
  environments = var.environments
}