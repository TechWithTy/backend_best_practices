# Basic Static Secrets Example
# Demonstrates creating and retrieving common application secrets

# Generate random JWT secret
resource "random_password" "jwt_secret" {
  length  = 32
  special = true
}

# Create API secrets
resource "infisical_secret" "stripe_key" {
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/api"
  
  name    = "STRIPE_SECRET_KEY"
  value   = var.stripe_secret_key
  comment = "Stripe payment processing key"
}

resource "infisical_secret" "jwt_secret" {
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/api"
  
  name    = "JWT_SECRET"
  value   = random_password.jwt_secret.result
  comment = "JWT signing secret - auto-generated"
}

# Create database secrets
resource "infisical_secret" "database_url" {
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database"
  
  name    = "DATABASE_URL"
  value   = "postgresql://${var.db_user}:${var.db_password}@${var.db_host}:${var.db_port}/${var.db_name}?sslmode=require"
  comment = "Main application database connection"
}

resource "infisical_secret" "redis_url" {
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database"
  
  name    = "REDIS_URL"
  value   = "redis://localhost:6379/0"
  comment = "Redis cache connection"
}

# Create third-party service secrets
resource "infisical_secret" "sendgrid_key" {
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/third-party"
  
  name    = "SENDGRID_API_KEY"
  value   = var.sendgrid_api_key
  comment = "SendGrid email service API key"
}

# Demonstrate secret retrieval using ephemeral resources
ephemeral "infisical_secret" "stripe_key_retrieval" {
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/api"
  secret_name  = "STRIPE_SECRET_KEY"
  
  depends_on = [infisical_secret.stripe_key]
}

ephemeral "infisical_secret" "database_url_retrieval" {
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database"
  secret_name  = "DATABASE_URL"
  
  depends_on = [infisical_secret.database_url]
}

# Example: Use retrieved secrets in Kubernetes
resource "kubernetes_secret" "app_secrets" {
  count = var.create_kubernetes_resources ? 1 : 0
  
  metadata {
    name      = "app-secrets"
    namespace = "default"
  }
  
  data = {
    STRIPE_SECRET_KEY = ephemeral.infisical_secret.stripe_key_retrieval.value
    DATABASE_URL      = ephemeral.infisical_secret.database_url_retrieval.value
  }
  
  type = "Opaque"
}