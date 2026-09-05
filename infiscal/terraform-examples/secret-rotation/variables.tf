variable "project_id" {
  description = "Infisical project ID"
  type        = string
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

# MySQL Rotation Variables
variable "enable_mysql_rotation" {
  description = "Enable MySQL credential rotation"
  type        = bool
  default     = false
}

variable "mysql_host" {
  description = "MySQL host"
  type        = string
  default     = ""
}

variable "mysql_port" {
  description = "MySQL port"
  type        = number
  default     = 3306
}

variable "mysql_database" {
  description = "MySQL database name"
  type        = string
  default     = ""
}

variable "mysql_admin_user" {
  description = "MySQL admin username for rotation operations"
  type        = string
  sensitive   = true
  default     = ""
}

variable "mysql_admin_password" {
  description = "MySQL admin password for rotation operations"
  type        = string
  sensitive   = true
  default     = ""
}

variable "mysql_username1" {
  description = "MySQL primary username (must exist in database)"
  type        = string
  default     = "app_user_primary"
}

variable "mysql_username2" {
  description = "MySQL secondary username (must exist in database)"
  type        = string
  default     = "app_user_secondary"
}

variable "mysql_initial_password1" {
  description = "Initial password for MySQL primary user"
  type        = string
  sensitive   = true
  default     = ""
}

variable "mysql_initial_password2" {
  description = "Initial password for MySQL secondary user"
  type        = string
  sensitive   = true
  default     = ""
}

variable "mysql_ssl_mode" {
  description = "MySQL SSL mode"
  type        = string
  default     = "required"
}

variable "mysql_ca_cert" {
  description = "MySQL CA certificate"
  type        = string
  default     = ""
}

variable "mysql_auto_rotation_enabled" {
  description = "Enable automatic rotation for MySQL"
  type        = bool
  default     = true
}

variable "mysql_rotation_interval_days" {
  description = "MySQL rotation interval in days"
  type        = number
  default     = 30
}

variable "mysql_rotation_hour_utc" {
  description = "Hour (UTC) to perform MySQL rotation"
  type        = number
  default     = 2
}

# AWS IAM Rotation Variables
variable "enable_aws_rotation" {
  description = "Enable AWS IAM credential rotation"
  type        = bool
  default     = false
}

variable "aws_access_key_id" {
  description = "AWS access key ID for rotation operations"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aws_secret_access_key" {
  description = "AWS secret access key for rotation operations"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_iam_username" {
  description = "AWS IAM username to rotate credentials for"
  type        = string
  default     = ""
}

variable "aws_iam_initial_access_key" {
  description = "Initial AWS IAM access key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aws_iam_initial_secret_key" {
  description = "Initial AWS IAM secret key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aws_auto_rotation_enabled" {
  description = "Enable automatic rotation for AWS IAM"
  type        = bool
  default     = true
}

variable "aws_rotation_interval_days" {
  description = "AWS IAM rotation interval in days"
  type        = number
  default     = 30
}

variable "aws_rotation_hour_utc" {
  description = "Hour (UTC) to perform AWS rotation"
  type        = number
  default     = 3
}

# PostgreSQL Rotation Variables
variable "enable_postgres_rotation" {
  description = "Enable PostgreSQL credential rotation"
  type        = bool
  default     = false
}

variable "postgres_host" {
  description = "PostgreSQL host"
  type        = string
  default     = ""
}

variable "postgres_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "postgres_database" {
  description = "PostgreSQL database name"
  type        = string
  default     = ""
}

variable "postgres_admin_user" {
  description = "PostgreSQL admin username for rotation operations"
  type        = string
  sensitive   = true
  default     = ""
}

variable "postgres_admin_password" {
  description = "PostgreSQL admin password for rotation operations"
  type        = string
  sensitive   = true
  default     = ""
}

variable "postgres_username1" {
  description = "PostgreSQL primary username (must exist in database)"
  type        = string
  default     = "app_user_primary"
}

variable "postgres_username2" {
  description = "PostgreSQL secondary username (must exist in database)"
  type        = string
  default     = "app_user_secondary"
}

variable "postgres_initial_password1" {
  description = "Initial password for PostgreSQL primary user"
  type        = string
  sensitive   = true
  default     = ""
}

variable "postgres_initial_password2" {
  description = "Initial password for PostgreSQL secondary user"
  type        = string
  sensitive   = true
  default     = ""
}

variable "postgres_ssl_mode" {
  description = "PostgreSQL SSL mode"
  type        = string
  default     = "require"
}

variable "postgres_auto_rotation_enabled" {
  description = "Enable automatic rotation for PostgreSQL"
  type        = bool
  default     = true
}

variable "postgres_rotation_interval_days" {
  description = "PostgreSQL rotation interval in days"
  type        = number
  default     = 30
}

variable "postgres_rotation_hour_utc" {
  description = "Hour (UTC) to perform PostgreSQL rotation"
  type        = number
  default     = 2
}

# Azure Rotation Variables
variable "enable_azure_rotation" {
  description = "Enable Azure client secret rotation"
  type        = bool
  default     = false
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = ""
}

variable "azure_client_id" {
  description = "Azure client ID for authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "azure_client_secret" {
  description = "Azure client secret for authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "azure_target_app_object_id" {
  description = "Azure app object ID to rotate secrets for"
  type        = string
  default     = ""
}

variable "azure_target_client_id" {
  description = "Azure client ID to rotate secrets for"
  type        = string
  default     = ""
}

variable "azure_initial_client_secret" {
  description = "Initial Azure client secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "azure_auto_rotation_enabled" {
  description = "Enable automatic rotation for Azure"
  type        = bool
  default     = true
}

variable "azure_rotation_interval_days" {
  description = "Azure rotation interval in days"
  type        = number
  default     = 30
}

variable "azure_rotation_hour_utc" {
  description = "Hour (UTC) to perform Azure rotation"
  type        = number
  default     = 4
}