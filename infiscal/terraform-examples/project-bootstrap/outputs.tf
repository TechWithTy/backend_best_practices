output "project_id" {
  value       = infisical_project.main.id
  description = "The ID of the created project"
}

output "project_slug" {
  value       = infisical_project.main.slug
  description = "The slug of the created project"
}

output "environments" {
  value       = local.environments
  description = "List of configured environments"
}

# Machine Identity Outputs
output "ci_cd_client_id" {
  value       = var.create_machine_identities ? infisical_identity.ci_cd[0].id : null
  description = "CI/CD machine identity client ID"
}

output "ci_cd_client_secret" {
  value       = var.create_machine_identities ? infisical_identity_universal_auth_client_secret.ci_cd[0].client_secret : null
  description = "CI/CD machine identity client secret"
  sensitive   = true
}

output "service_identities" {
  value = var.create_machine_identities ? {
    for key, identity in infisical_identity.services : key => {
      id   = identity.id
      name = identity.name
    }
  } : {}
  description = "Service machine identities"
}

output "folder_structure" {
  value       = local.folder_structure
  description = "Created folder structure"
}

output "created_tags" {
  value = {
    for key, tag in infisical_secret_tag.tags : key => {
      name  = tag.name
      slug  = tag.slug
      color = tag.color
    }
  }
  description = "Created secret tags"
}