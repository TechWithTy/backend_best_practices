# MySQL connection for rotation (required)
resource "infisical_app_connection_mysql" "rotation" {
  count = var.enable_mysql_rotation ? 1 : 0
  
  workspace_id = var.project_id
  
  name        = "mysql-rotation-connection"
  description = "MySQL connection for credential rotation"
  
  host     = var.mysql_host
  port     = var.mysql_port
  database = var.mysql_database
  
  # Admin credentials for rotation operations
  username = var.mysql_admin_user
  password = var.mysql_admin_password
  
  ssl_mode = var.mysql_ssl_mode
  ca_cert  = var.mysql_ca_cert
}

# Create initial secrets for MySQL users
resource "infisical_secret" "mysql_user1" {
  count = var.enable_mysql_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/mysql"
  
  name  = "MYSQL_USER1"
  value = var.mysql_username1
  
  comment = "MySQL primary user (rotated)"
}

resource "infisical_secret" "mysql_password1" {
  count = var.enable_mysql_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/mysql"
  
  name  = "MYSQL_PASSWORD1"
  value = var.mysql_initial_password1
  
  comment = "MySQL primary user password (auto-rotated)"
}

resource "infisical_secret" "mysql_user2" {
  count = var.enable_mysql_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/mysql"
  
  name  = "MYSQL_USER2"
  value = var.mysql_username2
  
  comment = "MySQL secondary user (rotated)"
}

resource "infisical_secret" "mysql_password2" {
  count = var.enable_mysql_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/mysql"
  
  name  = "MYSQL_PASSWORD2"
  value = var.mysql_initial_password2
  
  comment = "MySQL secondary user password (auto-rotated)"
}

# Active username/password secrets for application use
resource "infisical_secret" "mysql_active_username" {
  count = var.enable_mysql_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/mysql"
  
  name  = "MYSQL_USERNAME"
  value = var.mysql_username1  # Initially set to user1
  
  comment = "Active MySQL username (automatically switched during rotation)"
}

resource "infisical_secret" "mysql_active_password" {
  count = var.enable_mysql_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/mysql"
  
  name  = "MYSQL_PASSWORD"
  value = var.mysql_initial_password1  # Initially set to password1
  
  comment = "Active MySQL password (automatically rotated)"
}

# MySQL Credential Rotation Configuration
resource "infisical_secret_rotation_mysql_credentials" "app_users" {
  count = var.enable_mysql_rotation ? 1 : 0
  
  name          = "mysql-app-user-rotation"
  project_id    = var.project_id
  environment   = var.environment
  secret_path   = "/database/mysql"
  connection_id = infisical_app_connection_mysql.rotation[0].id
  
  parameters = {
    username1 = var.mysql_username1    # Must exist in database
    username2 = var.mysql_username2    # Must exist in database
  }
  
  secrets_mapping = {
    username = "MYSQL_USERNAME"  # Active username secret
    password = "MYSQL_PASSWORD"  # Active password secret
  }
  
  # Rotation configuration
  auto_rotation_enabled = var.mysql_auto_rotation_enabled
  rotation_interval     = var.mysql_rotation_interval_days
  
  rotate_at_utc = {
    hours   = var.mysql_rotation_hour_utc
    minutes = 0
  }
  
  description = "Rotate MySQL app user credentials every ${var.mysql_rotation_interval_days} days"
  
  depends_on = [
    infisical_app_connection_mysql.rotation,
    infisical_secret.mysql_active_username,
    infisical_secret.mysql_active_password
  ]
}