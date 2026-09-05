# Secret Syncing

Synchronize secrets from Infisical to external services like AWS Secrets Manager and GitHub. This guide shows how to wire up app connections with secret syncs.

## What This Does

- Creates app connections (authentication to external services)
- Sets up secret syncs using those connections
- Demonstrates the connection_id relationship between app connections and secret syncs

## Prerequisites

1. **Infisical project** already created (use `../project-bootstrap`)
2. **AWS account** with IAM permissions for Secrets Manager
3. **GitHub repository** with appropriate permissions
4. **Secrets to sync** in your Infisical project

## Quick Start

1. **Navigate to secret-syncing:**
   ```bash
   cd terraform-examples/secret-syncing
   ```

2. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Understanding App Connections and Secret Syncs

App connections and secret syncs work in tandem:
- **App Connection**: Stores authentication credentials for external services
- **Secret Sync**: Uses the connection_id to sync secrets to that service

### Step 1: Create App Connection

```hcl
# AWS App Connection (using IAM role - recommended)
resource "infisical_app_connection_aws" "aws_connection" {
  name   = "aws-secrets-manager-connection"
  method = "assume-role"
  
  credentials = {
    role_arn = var.aws_role_arn
  }
  
  description = "Connection for syncing secrets to AWS Secrets Manager"
}

# Alternative: AWS connection using access keys
resource "infisical_app_connection_aws" "aws_access_key_connection" {
  count = var.use_aws_access_keys ? 1 : 0
  
  name   = "aws-access-key-connection"
  method = "access-key"
  
  credentials = {
    access_key_id     = var.aws_access_key_id
    secret_access_key = var.aws_secret_access_key
  }
  
  description = "AWS connection using access keys"
}
```

### Step 2: Wire Up Secret Sync with Connection

```hcl
# AWS Secrets Manager Sync using the connection from Step 1
resource "infisical_secret_sync_aws_secrets_manager" "aws_sync" {
  count = var.enable_aws_sync ? 1 : 0
  
  name        = "aws-secrets-sync"
  description = "Sync application secrets to AWS Secrets Manager"
  
  project_id    = var.project_id
  environment   = var.environment
  secret_path   = var.aws_sync_secret_path
  connection_id = infisical_app_connection_aws.aws_connection.id  # <-- References the connection
  
  destination_config = {
    aws_region                      = var.aws_region
    mapping_behavior                = "many-to-one"
    aws_secrets_manager_secret_name = "${var.project_name}-secrets"
  }
  
  sync_options = {
    initial_sync_behavior = "overwrite-destination"
    aws_kms_key_id       = var.aws_kms_key_id
    
    tags = [
      {
        key   = "Environment"
        value = var.environment
      },
      {
        key   = "ManagedBy"
        value = "Infisical"
      }
    ]
  }
}

# GitHub Repository Secrets Sync
resource "infisical_secret_sync_github" "github_sync" {
  count = var.enable_github_sync ? 1 : 0
  
  name        = "github-secrets-sync"
  description = "Sync CI/CD secrets to GitHub repository"
  
  project_id    = var.project_id
  environment   = var.environment
  secret_path   = var.github_sync_secret_path
  connection_id = var.github_connection_id  # Pre-existing GitHub connection
  
  destination_config = {
    scope            = "repository"
    repository_owner = var.github_owner
    repository_name  = var.github_repository
  }
  
  sync_options = {
    initial_sync_behavior   = "overwrite-destination"
    key_schema             = "{{secretKey}}"  # Keep original secret names
    disable_secret_deletion = false
  }
}
```

## Configuration Examples

### AWS Secrets Manager Sync

This configuration syncs all secrets from `/api` folder to a single AWS secret:

```hcl
# Many-to-one mapping: All Infisical secrets → One AWS secret
destination_config = {
  aws_region                      = "us-east-1"
  mapping_behavior                = "many-to-one"
  aws_secrets_manager_secret_name = "myapp-api-secrets"
}
```

### GitHub Repository Sync

This configuration syncs secrets to GitHub Actions repository secrets:

```hcl
# Repository-level secrets for GitHub Actions
destination_config = {
  scope            = "repository"
  repository_owner = "my-org"
  repository_name  = "my-app"
}
```

## The Connection Flow

Here's the complete flow showing how to wire up app connections with secret syncs:

```hcl
# 1. First, create the app connection (stores AWS credentials)
resource "infisical_app_connection_aws" "aws_connection" {
  name   = "aws-connection"
  method = "assume-role"
  
  credentials = {
    role_arn = var.aws_role_arn
  }
}

# 2. Then, create a secret sync that references the connection
resource "infisical_secret_sync_aws_secrets_manager" "sync" {
  name          = "my-sync"
  project_id    = var.project_id
  connection_id = infisical_app_connection_aws.aws_connection.id  # <-- Uses connection ID
  
  destination_config = {
    aws_region                      = "us-east-1"
    mapping_behavior                = "many-to-one"
    aws_secrets_manager_secret_name = "my-app-secrets"
  }
}
```

**Key Point**: The `connection_id` field links the sync to the app connection, allowing the sync to use the stored credentials.

## Configuration Options

### Required Variables
- `project_id` - Your Infisical project ID
- `aws_role_arn` - AWS IAM role ARN for assume-role authentication
- `github_connection_id` - Pre-existing GitHub app connection ID

### Optional Configuration
- `aws_kms_key_id` - KMS key for AWS secret encryption
- `github_sync_secret_path` - Folder path to sync to GitHub
- `aws_sync_secret_path` - Folder path to sync to AWS

### Sync Behavior Options
- `overwrite-destination` - Replace all destination secrets
- `import-prioritize-source` - Merge, preferring Infisical values
- `import-prioritize-destination` - Merge, preferring destination values

## Benefits of This Approach

1. **Reusable Connections**: One app connection can be used by multiple syncs
2. **Clear Separation**: Authentication (connections) vs. sync logic (syncs) 
3. **Security**: Credentials stored securely in app connections
4. **Flexibility**: Easy to change sync destinations without recreating connections

## Next Steps

After setting up secret syncing:
1. **Monitor syncs** in the Infisical dashboard
2. **Set up alerts** for sync failures
3. **Test secret updates** to verify automatic syncing works

---

**Note**: GitHub app connections must be created through the Infisical UI first, then referenced by ID in Terraform. AWS connections can be created directly in Terraform as shown above.