# App Connections for Secret Syncing
# These connections establish authentication to external services

# AWS App Connection using IAM Role (Recommended)
resource "infisical_app_connection_aws" "aws_connection" {
  count = var.enable_aws_sync ? 1 : 0
  
  name   = "aws-secrets-manager-connection"
  method = "assume-role"
  
  credentials = {
    role_arn = var.aws_role_arn
  }
  
  description = "Connection for syncing secrets to AWS Secrets Manager"
}

# Alternative: AWS App Connection using Access Keys
resource "infisical_app_connection_aws" "aws_access_key_connection" {
  count = var.use_aws_access_keys ? 1 : 0
  
  name   = "aws-access-key-connection"
  method = "access-key"
  
  credentials = {
    access_key_id     = var.aws_access_key_id
    secret_access_key = var.aws_secret_access_key
  }
  
  description = "AWS connection using access keys"
}