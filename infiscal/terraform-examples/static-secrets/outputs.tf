output "created_secrets" {
  value = {
    api_secrets = [
      infisical_secret.stripe_key.name,
      infisical_secret.jwt_secret.name
    ]
    database_secrets = [
      infisical_secret.database_url.name,
      infisical_secret.redis_url.name
    ]
    third_party_secrets = [
      infisical_secret.sendgrid_key.name
    ]
  }
  description = "List of created secrets organized by category"
}

output "secret_locations" {
  value = {
    api_folder        = "/api"
    database_folder   = "/database"
    third_party_folder = "/third-party"
  }
  description = "Folder paths where secrets are organized"
}

output "ephemeral_example" {
  value = {
    stripe_value = ephemeral.infisical_secret.stripe_key_retrieval.value
    database_url = ephemeral.infisical_secret.database_url_retrieval.value
  }
  description = "Example of retrieved secret values using ephemeral resources"
  sensitive = true
}