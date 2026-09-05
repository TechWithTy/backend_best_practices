variable "project_id" {
  description = "Infisical project ID"
  type        = string
}

variable "project_slug" {
  description = "Infisical project slug"
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

# PostgreSQL Dynamic Secret Variables
variable "enable_postgres_dynamic" {
  description = "Enable PostgreSQL dynamic secrets"
  type        = bool
  default     = true
}

variable "postgres_host" {
  description = "PostgreSQL host"
  type        = string
  default     = "localhost"
}

variable "postgres_port" {
  description = "PostgreSQL port"
  type        = string
  default     = "5432"
}

variable "postgres_database" {
  description = "PostgreSQL database name"
  type        = string
  default     = "myapp"
}

variable "postgres_ca_cert" {
  description = "PostgreSQL CA certificate for SSL connections"
  type        = string
  default     = ""
}

variable "postgres_default_ttl" {
  description = "Default TTL for PostgreSQL dynamic credentials"
  type        = string
  default     = "2h"
}

variable "postgres_max_ttl" {
  description = "Maximum TTL for PostgreSQL dynamic credentials"
  type        = string
  default     = "4h"
}