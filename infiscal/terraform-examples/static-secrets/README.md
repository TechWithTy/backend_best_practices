# Static Secrets Management

Create and manage traditional secrets like API keys, passwords, and configuration values with organized patterns and best practices.

## What This Does

- Creates basic secrets with proper organization
- Implements environment-specific secret patterns  
- Organizes secrets by service and purpose
- Handles complex secret types (JSON, certificates, generated values)
- Demonstrates secure secret retrieval using ephemeral resources

## Prerequisites

1. Infisical project already created (use `../project-bootstrap`)
2. Terraform >= 1.10.0 installed
3. Machine identity configured

## Quick Start

1. **Navigate to static-secrets:**
   ```bash
   cd terraform-examples/static-secrets
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

