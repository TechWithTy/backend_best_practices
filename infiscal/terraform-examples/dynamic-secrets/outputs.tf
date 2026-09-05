output "postgres_dynamic_secret_name" {
  value       = var.enable_postgres_dynamic ? infisical_dynamic_secret_sql_database.postgres_readonly[0].name : null
  description = "Name of the PostgreSQL dynamic secret"
}

output "postgres_dynamic_secret_path" {
  value       = var.enable_postgres_dynamic ? infisical_dynamic_secret_sql_database.postgres_readonly[0].path : null
  description = "Path where PostgreSQL dynamic secret is configured"
}

output "usage_instructions" {
  value = var.enable_postgres_dynamic ? {
    cli_usage = "infisical secrets get --path=/database/dynamic --env=${var.environment}"
    sdk_example = "client.createDynamicSecretLease({ dynamicSecretName: '${infisical_dynamic_secret_sql_database.postgres_readonly[0].name}', ttl: '1h' })"
  } : null
  description = "Instructions for using the dynamic secret"
}