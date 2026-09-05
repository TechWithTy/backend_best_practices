# Optional: Machine Identities for CI/CD and Services
# Enable by setting create_machine_identities = true

# CI/CD Machine Identity
resource "infisical_identity" "ci_cd" {
  count = var.create_machine_identities ? 1 : 0
  
  name   = "github-actions"
  role   = "admin"
  org_id = var.organization_id
}

# Configure Universal Auth for the machine identity
resource "infisical_identity_universal_auth" "ci_cd" {
  count = var.create_machine_identities ? 1 : 0
  
  identity_id = infisical_identity.ci_cd[0].id
  
  access_token_ttl     = 3600   # 1 hour
  access_token_max_ttl = 86400  # 24 hours
  
  access_token_trusted_ips = var.ci_cd_trusted_ips
}

# Get client secret for the universal auth
resource "infisical_identity_universal_auth_client_secret" "ci_cd" {
  count = var.create_machine_identities ? 1 : 0
  
  identity_id = infisical_identity.ci_cd[0].id
  description = "GitHub Actions CI/CD client secret"
  ttl         = 0  # No expiration
}

# Application service identities
resource "infisical_identity" "services" {
  for_each = var.create_machine_identities ? var.services : {}
  
  name   = "${each.key}-service"
  role   = "member"
  org_id = var.organization_id
}

resource "infisical_identity_universal_auth" "services" {
  for_each = var.create_machine_identities ? var.services : {}
  
  identity_id          = infisical_identity.services[each.key].id
  access_token_ttl     = 7200   # 2 hours
  access_token_max_ttl = 86400  # 24 hours
}

# Add identities to project
resource "infisical_project_identity" "ci_cd" {
  count = var.create_machine_identities ? 1 : 0
  
  project_id  = infisical_project.main.id
  identity_id = infisical_identity.ci_cd[0].id
  roles = [
    {
      role_slug = "admin"
    }
  ]
}

resource "infisical_project_identity" "services" {
  for_each = var.create_machine_identities ? var.services : {}
  
  project_id  = infisical_project.main.id
  identity_id = infisical_identity.services[each.key].id
  roles = [
    {
      role_slug = "developer"
    }
  ]
}