output "mysql_rotation" {
  value = var.enable_mysql_rotation ? {
    connection_id     = infisical_app_connection_mysql.rotation[0].id
    rotation_name     = infisical_secret_rotation_mysql_credentials.app_users[0].name
    active_username   = "MYSQL_USERNAME"
    active_password   = "MYSQL_PASSWORD"
    rotation_interval = "${var.mysql_rotation_interval_days} days"
    rotation_time     = "${var.mysql_rotation_hour_utc}:00 UTC"
  } : null
  description = "MySQL rotation configuration details"
}

output "aws_rotation" {
  value = var.enable_aws_rotation ? {
    connection_id     = infisical_app_connection_aws.rotation[0].id
    rotation_name     = infisical_secret_rotation_aws_iam_user_secret.iam_user[0].name
    iam_username      = var.aws_iam_username
    rotation_interval = "${var.aws_rotation_interval_days} days"
    rotation_time     = "${var.aws_rotation_hour_utc}:00 UTC"
  } : null
  description = "AWS IAM rotation configuration details"
}

output "postgres_rotation" {
  value = var.enable_postgres_rotation ? {
    connection_id     = infisical_app_connection_postgres.rotation[0].id
    rotation_name     = infisical_secret_rotation_postgres_credentials.app_users[0].name
    active_username   = "POSTGRES_USERNAME"
    active_password   = "POSTGRES_PASSWORD"
    rotation_interval = "${var.postgres_rotation_interval_days} days"
    rotation_time     = "${var.postgres_rotation_hour_utc}:00 UTC"
  } : null
  description = "PostgreSQL rotation configuration details"
}

output "azure_rotation" {
  value = var.enable_azure_rotation ? {
    connection_id     = infisical_app_connection_azure.rotation[0].id
    rotation_name     = infisical_secret_rotation_azure_client_secret.app_client[0].name
    client_id         = var.azure_target_client_id
    rotation_interval = "${var.azure_rotation_interval_days} days"
    rotation_time     = "${var.azure_rotation_hour_utc}:00 UTC"
  } : null
  description = "Azure client secret rotation configuration details"
}

output "rotation_summary" {
  value = {
    mysql_enabled    = var.enable_mysql_rotation
    aws_enabled      = var.enable_aws_rotation
    postgres_enabled = var.enable_postgres_rotation
    azure_enabled    = var.enable_azure_rotation
    total_rotations  = (var.enable_mysql_rotation ? 1 : 0) + (var.enable_aws_rotation ? 1 : 0) + (var.enable_postgres_rotation ? 1 : 0) + (var.enable_azure_rotation ? 1 : 0)
  }
  description = "Summary of enabled rotations"
}