# Project folder organization and structure
# This file demonstrates how to organize secrets within projects using folders and tags

locals {
  # Standard folder structure for each environment
  folder_structure = [
    "/api",
    "/database", 
    "/third-party",
    "/infrastructure",
    "/ci-cd"
  ]
  
  # Create all combinations
  folder_matrix = flatten([
    for env in var.environments : [
      for folder in local.folder_structure : {
        key    = "${env}${folder}"
        env    = env
        folder = folder
      }
    ]
  ])
}

# Create folder structure markers
resource "infisical_secret" "folder_readme" {
  for_each = { for item in local.folder_matrix : item.key => item }
  
  workspace_id = infisical_project.main.id
  env_slug     = each.value.env
  folder_path  = each.value.folder
  
  name  = "_README"
  value = "Folder: ${each.value.folder} in ${each.value.env} environment"
  
  comment = "Folder structure marker"
}

# Create tags for secret organization
resource "infisical_secret_tag" "tags" {
  for_each = {
    critical       = { name = "Critical", color = "#FF0000" }
    sensitive      = { name = "Sensitive", color = "#FFA500" }
    public         = { name = "Public", color = "#00FF00" }
    deprecated     = { name = "Deprecated", color = "#808080" }
    rotate_monthly = { name = "Rotate Monthly", color = "#0000FF" }
  }
  
  project_id = infisical_project.main.id
  name       = each.value.name
  slug       = each.key
  color      = each.value.color
}