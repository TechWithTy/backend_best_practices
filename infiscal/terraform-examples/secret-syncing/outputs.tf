output "aws_connection_id" {
  value       = var.enable_aws_sync ? (var.use_aws_access_keys ? infisical_app_connection_aws.aws_access_key_connection[0].id : infisical_app_connection_aws.aws_connection[0].id) : null
  description = "ID of the created AWS app connection"
}

output "aws_sync_id" {
  value       = var.enable_aws_sync ? infisical_secret_sync_aws_secrets_manager.aws_sync[0].id : null
  description = "ID of the AWS Secrets Manager sync"
}

output "github_sync_id" {
  value       = var.enable_github_sync ? infisical_secret_sync_github.github_sync[0].id : null
  description = "ID of the GitHub repository sync"
}

output "sync_summary" {
  value = {
    aws_sync_enabled    = var.enable_aws_sync
    github_sync_enabled = var.enable_github_sync
    total_syncs         = (var.enable_aws_sync ? 1 : 0) + (var.enable_github_sync ? 1 : 0)
    
    aws_config = var.enable_aws_sync ? {
      auth_method     = var.use_aws_access_keys ? "access-key" : "assume-role"
      region          = var.aws_region
      secret_path     = var.aws_sync_secret_path
      destination     = "${var.project_name}-secrets"
    } : null
    
    github_config = var.enable_github_sync ? {
      repository   = "${var.github_owner}/${var.github_repository}"
      secret_path  = var.github_sync_secret_path
      scope        = "repository"
    } : null
  }
  description = "Summary of configured secret syncs"
}