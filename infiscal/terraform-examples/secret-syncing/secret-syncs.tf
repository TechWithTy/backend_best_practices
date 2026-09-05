# Secret Syncs using App Connections
# These syncs use the connection IDs from app-connections.tf

# AWS Secrets Manager Sync
resource "infisical_secret_sync_aws_secrets_manager" "aws_sync" {
  count = var.enable_aws_sync ? 1 : 0
  
  name        = "aws-secrets-sync"
  description = "Sync application secrets to AWS Secrets Manager"
  
  project_id    = var.project_id
  environment   = var.environment
  secret_path   = var.aws_sync_secret_path
  connection_id = var.use_aws_access_keys ? infisical_app_connection_aws.aws_access_key_connection[0].id : infisical_app_connection_aws.aws_connection[0].id
  
  destination_config = {
    aws_region                      = var.aws_region
    mapping_behavior                = "many-to-one"
    aws_secrets_manager_secret_name = "${var.project_name}-secrets"
  }
  
  sync_options = {
    initial_sync_behavior = "overwrite-destination"
    aws_kms_key_id       = var.aws_kms_key_id
    
    tags = [
      {
        key   = "Environment"
        value = var.environment
      },
      {
        key   = "ManagedBy"
        value = "Infisical"
      },
      {
        key   = "Project"
        value = var.project_name
      }
    ]
  }
  
  auto_sync_enabled = true
}

# GitHub Repository Secrets Sync
resource "infisical_secret_sync_github" "github_sync" {
  count = var.enable_github_sync ? 1 : 0
  
  name        = "github-secrets-sync"
  description = "Sync CI/CD secrets to GitHub repository"
  
  project_id    = var.project_id
  environment   = var.environment
  secret_path   = var.github_sync_secret_path
  connection_id = var.github_connection_id  # Pre-existing GitHub connection from UI
  
  destination_config = {
    scope            = "repository"
    repository_owner = var.github_owner
    repository_name  = var.github_repository
  }
  
  sync_options = {
    initial_sync_behavior   = "overwrite-destination"
    key_schema             = "{{secretKey}}"  # Keep original secret names
    disable_secret_deletion = false
  }
  
  auto_sync_enabled = true
}