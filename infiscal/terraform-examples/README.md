# Infisical Terraform Examples

Production-ready terraform boilerplate for Infisical secret management. **5 focused examples** covering the most common use cases.

## Quick Start Path

### **1. Essential Setup** (Start Here)
- **[project-bootstrap/](project-bootstrap/)** - Complete project setup with environments, folders, and machine identities

### **2. Core Features** (Most Common)
- **[static-secrets/](static-secrets/)** - Traditional secret management (start here for secrets)

### **3. Advanced Features** (Enterprise)
- **[dynamic-secrets/](dynamic-secrets/)** - Advanced: Temporary credential generation
- **[secret-rotation/](secret-rotation/)** - Enterprise: Automated credential lifecycle  
- **[secret-syncing/](secret-syncing/)** - External store synchronization (AWS + GitHub)

## Usage Recommendation

**For most teams:**
1. Start with `project-bootstrap/` then `static-secrets/`
2. Only use advanced features if you have specific enterprise requirements

**Advanced features require significant setup and are designed for enterprise environments.**

## Instant Setup

```bash
# 1. Quick start (15 minutes)
cd terraform-examples/project-bootstrap
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your Infisical credentials
terraform init && terraform apply

# 2. Expand as needed
cd ../static-secrets
# Configure based on your needs
```

## Complete Structure

```
terraform-examples/
├── README.md                    # This file
├── project-bootstrap/           # Complete project setup
├── static-secrets/              # Traditional secret management
├── dynamic-secrets/             # Advanced: Temporary credentials
├── secret-rotation/             # Enterprise: Automated rotation
└── secret-syncing/              # Sync to AWS + GitHub
```

## Module Usage

Examples work as standalone configurations or as modules:

```hcl
# Use project-bootstrap as a module
module "infisical_bootstrap" {
  source = "./terraform-examples/project-bootstrap"
  
  project_name = "my-app"
  project_slug = "my-app"
  
  # Optional: Enable machine identities for CI/CD
  create_machine_identities = true
  organization_id           = "your-org-id"
  
  infisical_client_id     = var.infisical_client_id
  infisical_client_secret = var.infisical_client_secret
}

# Reference bootstrap outputs in other modules
module "static_secrets" {
  source = "./terraform-examples/static-secrets"
  
  project_id = module.infisical_bootstrap.project_id
  # ... other configuration
}
```

## Prerequisites

- **Terraform** >= 1.10.0 (required for ephemeral resources)
- **Infisical account** with machine identity created
- **Target services** (databases, cloud accounts) for advanced features

## Best Practices Implemented

All examples follow Infisical and Terraform best practices:
- **Ephemeral resources** for secret retrieval (no secrets in state)
- **Machine identity authentication** (recommended over service tokens)
- **Least privilege** access controls and proper RBAC
- **Organized folder structure** for scalability
- **SSL/TLS** for all database and service connections
- **Comprehensive documentation** with real-world examples

## When to Use Each Example

| Example | Best For | Complexity |
|---------|----------|------------|
| **project-bootstrap** | Complete project setup, production-ready | Simple |
| **static-secrets** | Most secret management needs | Simple |
| **dynamic-secrets** | Short-lived credentials, compliance | Advanced |
| **secret-rotation** | Enterprise security requirements | Advanced |
| **secret-syncing** | Multi-service secret distribution | Medium |

## Support

- **Individual README files** in each folder have detailed instructions
- **[Infisical Documentation](https://infisical.com/docs)** for general help
- **[Terraform Provider Docs](https://registry.terraform.io/providers/Infisical/infisical/latest/docs)** for resource reference
- **[GitHub Issues](https://github.com/anthropics/claude-code/issues)** for example-specific problems

## Security Notes

- All examples use **ephemeral resources** to prevent secrets in Terraform state
- **Machine identity authentication** is used throughout (more secure than service tokens)
- Examples include **IP restrictions** and **TTL configurations** where applicable
- **Audit logging** is enabled in project-bootstrap and enterprise examples
- Sensitive variables are properly marked as `sensitive = true`

---

**Start with `project-bootstrap/` - it covers 80% of real-world Infisical usage.**