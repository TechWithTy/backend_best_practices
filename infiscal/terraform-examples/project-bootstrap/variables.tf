variable "project_name" {
  description = "Name of the Infisical project"
  type        = string
  default     = "my-app"
}

variable "project_slug" {
  description = "URL-friendly identifier for the project"
  type        = string
  default     = "my-app"
}

variable "environments" {
  description = "List of environments to create"
  type        = list(string)
  default     = ["dev", "staging", "prod"]
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

variable "stripe_prod_key" {
  description = "Stripe production API key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "stripe_test_key" {
  description = "Stripe test API key"
  type        = string
  sensitive   = true
  default     = ""
}

# Machine Identity Variables
variable "create_machine_identities" {
  description = "Whether to create machine identities for CI/CD and services"
  type        = bool
  default     = false
}

variable "organization_id" {
  description = "Infisical organization ID (required if creating machine identities)"
  type        = string
  default     = ""
}

variable "services" {
  description = "Map of services to create identities for"
  type        = map(object({
    description = string
  }))
  default = {}
}

variable "ci_cd_trusted_ips" {
  description = "Trusted IP addresses for CI/CD access"
  type = list(object({
    ip_address = string
  }))
  default = [
    {
      ip_address = "0.0.0.0/0"  # Allow from anywhere - restrict in production
    }
  ]
}