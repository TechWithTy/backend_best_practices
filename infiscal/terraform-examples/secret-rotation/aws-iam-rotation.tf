# AWS connection for rotation (required)
resource "infisical_app_connection_aws" "rotation" {
  count = var.enable_aws_rotation ? 1 : 0
  
  workspace_id = var.project_id
  
  name        = "aws-rotation-connection"
  description = "AWS connection for IAM credential rotation"
  
  access_key_id     = var.aws_access_key_id
  secret_access_key = var.aws_secret_access_key
  region           = var.aws_region
}

# Create the AWS IAM user secrets to be rotated
resource "infisical_secret" "aws_iam_access_key" {
  count = var.enable_aws_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/aws/iam"
  
  name  = "AWS_ACCESS_KEY_ID"
  value = var.aws_iam_initial_access_key
  
  comment = "AWS IAM access key (auto-rotated)"
}

resource "infisical_secret" "aws_iam_secret" {
  count = var.enable_aws_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/aws/iam"
  
  name  = "AWS_SECRET_ACCESS_KEY"
  value = var.aws_iam_initial_secret_key
  
  comment = "AWS IAM secret key (auto-rotated)"
}

# Configure AWS IAM user secret rotation
resource "infisical_secret_rotation_aws_iam_user_secret" "iam_user" {
  count = var.enable_aws_rotation ? 1 : 0
  
  name          = "aws-iam-user-secret-rotation"
  project_id    = var.project_id
  environment   = var.environment
  secret_path   = "/aws/iam"
  connection_id = infisical_app_connection_aws.rotation[0].id
  
  parameters = {
    user_name = var.aws_iam_username
    region    = var.aws_region
  }
  
  secrets_mapping = {
    access_key_id     = "AWS_ACCESS_KEY_ID"
    secret_access_key = "AWS_SECRET_ACCESS_KEY"
  }
  
  # Rotation configuration
  auto_rotation_enabled = var.aws_auto_rotation_enabled
  rotation_interval     = var.aws_rotation_interval_days
  
  rotate_at_utc = {
    hours   = var.aws_rotation_hour_utc
    minutes = 0
  }
  
  description = "Rotate AWS IAM user access keys every ${var.aws_rotation_interval_days} days"
  
  depends_on = [
    infisical_app_connection_aws.rotation,
    infisical_secret.aws_iam_access_key,
    infisical_secret.aws_iam_secret
  ]
}