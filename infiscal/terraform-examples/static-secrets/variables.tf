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

# Secret values
variable "stripe_secret_key" {
  description = "Stripe secret key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "sendgrid_api_key" {
  description = "SendGrid API key"
  type        = string
  sensitive   = true
  default     = ""
}

# Database configuration
variable "db_host" {
  description = "Database host"
  type        = string
  default     = "localhost"
}

variable "db_port" {
  description = "Database port"
  type        = string
  default     = "5432"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "myapp"
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "app_user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# Optional: Create Kubernetes resources for demonstration
variable "create_kubernetes_resources" {
  description = "Whether to create Kubernetes resources"
  type        = bool
  default     = false
}