# Azure connection for rotation
resource "infisical_app_connection_azure" "rotation" {
  count = var.enable_azure_rotation ? 1 : 0
  
  workspace_id = var.project_id
  
  name        = "azure-rotation-connection"
  description = "Azure connection for client secret rotation"
  
  tenant_id     = var.azure_tenant_id
  client_id     = var.azure_client_id
  client_secret = var.azure_client_secret
}

# Create the secret to be rotated
resource "infisical_secret" "azure_client_id" {
  count = var.enable_azure_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/azure"
  
  name  = "AZURE_CLIENT_ID"
  value = var.azure_target_client_id
  
  comment = "Azure client ID"
}

resource "infisical_secret" "azure_client_secret" {
  count = var.enable_azure_rotation ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/azure"
  
  name  = "AZURE_CLIENT_SECRET"
  value = var.azure_initial_client_secret
  
  comment = "Azure client secret (auto-rotated)"
}

# Configure Azure client secret rotation
resource "infisical_secret_rotation_azure_client_secret" "app_client" {
  count = var.enable_azure_rotation ? 1 : 0
  
  name          = "azure-client-secret-rotation"
  project_id    = var.project_id
  environment   = var.environment
  secret_path   = "/azure"
  connection_id = infisical_app_connection_azure.rotation[0].id
  
  parameters = {
    object_id = var.azure_target_app_object_id
    client_id = var.azure_target_client_id
  }
  
  secrets_mapping = {
    client_id     = "AZURE_CLIENT_ID"
    client_secret = "AZURE_CLIENT_SECRET"
  }
  
  # Rotation configuration
  auto_rotation_enabled = var.azure_auto_rotation_enabled
  rotation_interval     = var.azure_rotation_interval_days
  
  rotate_at_utc = {
    hours   = var.azure_rotation_hour_utc
    minutes = 0
  }
  
  description = "Rotate Azure client secret every ${var.azure_rotation_interval_days} days"
  
  depends_on = [
    infisical_app_connection_azure.rotation,
    infisical_secret.azure_client_id,
    infisical_secret.azure_client_secret
  ]
}