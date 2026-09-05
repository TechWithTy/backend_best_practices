# Project Bootstrap

Complete project setup with environments, folder structure, secret organization, and optional machine identities. This example covers everything needed to get started with Infisical in production.

## What This Creates

### Core Setup
- **Project**: Creates the main Infisical project
- **Environments**: Standard dev, staging, prod environments  
- **Folder Structure**: Organized folders (/api, /database, /third-party, /infrastructure, /ci-cd)
- **Secret Tags**: Color-coded organization (critical, sensitive, public, etc.)
- **Sample Secrets**: Basic secrets like Stripe keys and database credentials

### Optional: Machine Identities
- **CI/CD Identity**: GitHub Actions authentication with Universal Auth
- **Service Identities**: Application-specific identities with restricted access
- **Project Access**: Automatic assignment to project with appropriate roles

## Quick Start (15 minutes)

1. **Copy and configure:**
   ```bash
   cd terraform-examples/project-bootstrap
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your Infisical credentials
   ```

2. **Deploy basic setup:**
   ```bash
   terraform init
   terraform apply
   ```

3. **Optional: Add machine identities:**
   ```bash
   # Edit terraform.tfvars:
   create_machine_identities = true
   organization_id = "your-org-id"
   
   terraform apply
   ```

## Configuration Options

### Basic Configuration
```hcl
# Required
project_name = "my-app" 
project_slug = "my-app"
infisical_client_id = "your-machine-identity-client-id"
infisical_client_secret = "your-machine-identity-client-secret"

# Optional
environments = ["dev", "staging", "prod"]  # Customize environments
stripe_prod_key = "sk_live_..."            # Add your API keys
```

### Machine Identity Setup
```hcl
create_machine_identities = true
organization_id = "your-org-id"

services = {
  api = { description = "Main API service" }
  worker = { description = "Background worker" }
}

# Restrict access by IP (recommended for production)
ci_cd_trusted_ips = [
  { ip_address = "192.168.1.0/24" }  # Your office/CI IP range
]
```

## Folder Structure Created

```
project-name/
├── dev/
│   ├── /api              # API-specific secrets
│   ├── /database         # Database credentials
│   ├── /third-party      # External service keys
│   ├── /infrastructure   # AWS, GCP, etc.
│   └── /ci-cd            # CI/CD specific secrets
├── staging/
│   └── (same structure)
└── prod/
    └── (same structure)
```

## Secret Tags Available

- **Critical**: Must-protect secrets (production DB passwords, etc.)
- **Sensitive**: Important but not critical (API keys, etc.)  
- **Public**: Non-sensitive configuration
- **Deprecated**: Secrets marked for removal
- **Rotate Monthly**: Secrets requiring regular rotation

## Using as a Module

```hcl
module "infisical_bootstrap" {
  source = "./terraform-examples/project-bootstrap"
  
  project_name = "my-app"
  project_slug = "my-app"
  
  # Optional: Enable machine identities
  create_machine_identities = true
  organization_id           = "your-org-id"
  
  services = {
    api    = { description = "Main API service" }
    worker = { description = "Background worker" }
  }
  
  infisical_client_id     = var.infisical_client_id
  infisical_client_secret = var.infisical_client_secret
}

# Reference outputs in other modules
output "project_id" {
  value = module.infisical_bootstrap.project_id
}

output "ci_cd_credentials" {
  value = {
    client_id     = module.infisical_bootstrap.ci_cd_client_id
    client_secret = module.infisical_bootstrap.ci_cd_client_secret
  }
  sensitive = true
}
```

## Next Steps

After running this bootstrap:

1. **Use in CI/CD**: Configure GitHub Actions with the machine identity credentials
2. **Add More Secrets**: Use the created folder structure to organize your secrets
3. **Advanced Features**: Explore other examples for dynamic secrets, rotation, and syncing

## Prerequisites

- **Terraform** >= 1.10.0
- **Infisical account** with machine identity created
- **Organization access** (if creating machine identities)