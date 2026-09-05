variable "project_id" {
  description = "Infisical project ID"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "infisical_host" {
  description = "Infisical host URL"
  type        = string
  default     = "https://app.infisical.com"
}

variable "infisical_client_id" {
  description = "Infisical machine identity client ID"
  type        = string
  sensitive   = true
}

variable "infisical_client_secret" {
  description = "Infisical machine identity client secret"
  type        = string
  sensitive   = true
}

# AWS Sync Configuration
variable "enable_aws_sync" {
  description = "Enable AWS Secrets Manager sync"
  type        = bool
  default     = false
}

variable "use_aws_access_keys" {
  description = "Use AWS access keys instead of IAM role (not recommended for production)"
  type        = bool
  default     = false
}

variable "aws_role_arn" {
  description = "AWS IAM role ARN for assume-role authentication"
  type        = string
  default     = ""
}

variable "aws_access_key_id" {
  description = "AWS access key ID (only if using access key method)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aws_secret_access_key" {
  description = "AWS secret access key (only if using access key method)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_sync_secret_path" {
  description = "Infisical secret path to sync to AWS"
  type        = string
  default     = "/api"
}

variable "aws_kms_key_id" {
  description = "AWS KMS key ID for encryption (optional)"
  type        = string
  default     = ""
}

# GitHub Sync Configuration
variable "enable_github_sync" {
  description = "Enable GitHub secrets sync"
  type        = bool
  default     = false
}

variable "github_connection_id" {
  description = "GitHub app connection ID (create in Infisical UI first)"
  type        = string
  default     = ""
}

variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
  default     = ""
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
  default     = ""
}

variable "github_sync_secret_path" {
  description = "Infisical secret path to sync to GitHub"
  type        = string
  default     = "/ci-cd"
}