# PostgreSQL Dynamic Secret Configuration
# This demonstrates creating temporary database credentials on-demand

# Retrieve admin credentials from Infisical (must be pre-stored)
data "infisical_secret" "postgres_admin_user" {
  env_slug     = var.environment
  workspace_id = var.project_id
  secret_path  = "/database/admin"
  secret_name  = "DB_ADMIN_USER"
}

data "infisical_secret" "postgres_admin_pass" {
  env_slug     = var.environment
  workspace_id = var.project_id
  secret_path  = "/database/admin"
  secret_name  = "DB_ADMIN_PASS"
}

# PostgreSQL Read-Only Dynamic Secret
resource "infisical_dynamic_secret_sql_database" "postgres_readonly" {
  count = var.enable_postgres_dynamic ? 1 : 0
  
  name             = "postgres-readonly-access"
  project_slug     = var.project_slug
  environment_slug = var.environment
  path             = "/database/dynamic"
  
  default_ttl = var.postgres_default_ttl
  max_ttl     = var.postgres_max_ttl
  
  configuration = {
    client   = "postgres"
    host     = var.postgres_host
    port     = var.postgres_port
    database = var.postgres_database
    
    # Admin credentials from Infisical
    username = data.infisical_secret.postgres_admin_user.value
    password = data.infisical_secret.postgres_admin_pass.value
    
    # SQL for creating temporary users
    creation_statement = <<-EOT
      CREATE ROLE "{{username}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{username}}";
      GRANT USAGE ON SCHEMA public TO "{{username}}";
    EOT
    
    # SQL for removing users when credentials expire
    revocation_statement = <<-EOT
      DROP ROLE IF EXISTS "{{username}}";
    EOT
    
    # Optional: SSL certificate for secure connections
    ca = var.postgres_ca_cert != "" ? var.postgres_ca_cert : null
  }
}