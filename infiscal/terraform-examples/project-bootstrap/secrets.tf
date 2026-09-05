# Add database credentials
resource "infisical_secret" "database_url" {
  for_each = toset(local.environments)
  
  name         = "DATABASE_URL"
  value        = "postgresql://user:pass@${each.key}-db.internal:5432/app"
  env_slug     = each.key
  workspace_id = infisical_project.main.id
  folder_path  = "/database"
  
  comment = "Main database connection for ${each.key}"
}

# Add API keys
resource "infisical_secret" "api_keys" {
  for_each = toset(local.environments)
  
  name         = "STRIPE_KEY"
  value        = each.key == "prod" ? var.stripe_prod_key : var.stripe_test_key
  env_slug     = each.key
  workspace_id = infisical_project.main.id
  folder_path  = "/api"
  
  comment = "Stripe API key"
}

# Generate random passwords
resource "random_password" "jwt" {
  length  = 32
  special = true
}

resource "random_password" "session" {
  length  = 32
  special = true
}

resource "random_password" "encryption" {
  length  = 32
  special = true
}

# Add multiple secrets at once
locals {
  common_secrets = {
    JWT_SECRET     = random_password.jwt.result
    SESSION_SECRET = random_password.session.result
    ENCRYPTION_KEY = random_password.encryption.result
  }
}

resource "infisical_secret" "common" {
  for_each = {
    for item in flatten([
      for env in local.environments : [
        for key, value in local.common_secrets : {
          id    = "${env}-${key}"
          env   = env
          key   = key
          value = value
        }
      ]
    ]) : item.id => item
  }
  
  name         = each.value.key
  value        = each.value.value
  env_slug     = each.value.env
  workspace_id = infisical_project.main.id
  folder_path  = "/api"
}