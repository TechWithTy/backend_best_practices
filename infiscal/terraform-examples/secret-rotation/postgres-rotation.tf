# PostgreSQL connection for rotation
resource "infisical_app_connection_postgres" "rotation" {
  count = var.enable_postgres_rotation ? 1 : 0
  
  workspace_id = var.project_id
  
  name        = "postgres-rotation-connection"
  description = "PostgreSQL connection for credential rotation"
  
  host     = var.postgres_host
  port     = var.postgres_port
  database = var.postgres_database
  
  username = var.postgres_admin_user
  password = var.postgres_admin_password
  
  ssl_mode = var.postgres_ssl_mode
}

# Create initial secrets for PostgreSQL users
resource "infisical_secret" "postgres_user1" {
  count = var.enable_postgres_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/postgres"
  
  name  = "POSTGRES_USER1"
  value = var.postgres_username1
  
  comment = "PostgreSQL primary user (rotated)"
}

resource "infisical_secret" "postgres_password1" {
  count = var.enable_postgres_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/postgres"
  
  name  = "POSTGRES_PASSWORD1"
  value = var.postgres_initial_password1
  
  comment = "PostgreSQL primary user password (auto-rotated)"
}

resource "infisical_secret" "postgres_user2" {
  count = var.enable_postgres_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/postgres"
  
  name  = "POSTGRES_USER2"
  value = var.postgres_username2
  
  comment = "PostgreSQL secondary user (rotated)"
}

resource "infisical_secret" "postgres_password2" {
  count = var.enable_postgres_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/postgres"
  
  name  = "POSTGRES_PASSWORD2"
  value = var.postgres_initial_password2
  
  comment = "PostgreSQL secondary user password (auto-rotated)"
}

# Active username/password secrets for application use
resource "infisical_secret" "postgres_active_username" {
  count = var.enable_postgres_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/postgres"
  
  name  = "POSTGRES_USERNAME"
  value = var.postgres_username1  # Initially set to user1
  
  comment = "Active PostgreSQL username (automatically switched during rotation)"
}

resource "infisical_secret" "postgres_active_password" {
  count = var.enable_postgres_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/postgres"
  
  name  = "POSTGRES_PASSWORD"
  value = var.postgres_initial_password1  # Initially set to password1
  
  comment = "Active PostgreSQL password (automatically rotated)"
}

# PostgreSQL Credential Rotation Configuration
resource "infisical_secret_rotation_postgres_credentials" "app_users" {
  count = var.enable_postgres_rotation ? 1 : 0
  
  name          = "postgres-app-user-rotation"
  project_id    = var.project_id
  environment   = var.environment
  secret_path   = "/database/postgres"
  connection_id = infisical_app_connection_postgres.rotation[0].id
  
  parameters = {
    username1 = var.postgres_username1
    username2 = var.postgres_username2
  }
  
  secrets_mapping = {
    username = "POSTGRES_USERNAME"
    password = "POSTGRES_PASSWORD"
  }
  
  # Rotation configuration
  auto_rotation_enabled = var.postgres_auto_rotation_enabled
  rotation_interval     = var.postgres_rotation_interval_days
  
  rotate_at_utc = {
    hours   = var.postgres_rotation_hour_utc
    minutes = 0
  }
  
  description = "Rotate PostgreSQL app user credentials every ${var.postgres_rotation_interval_days} days"
  
  depends_on = [
    infisical_app_connection_postgres.rotation,
    infisical_secret.postgres_active_username,
    infisical_secret.postgres_active_password
  ]
}