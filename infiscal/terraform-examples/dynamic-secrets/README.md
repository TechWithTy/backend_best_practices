# Dynamic Secrets

Generate temporary credentials on-demand using dynamic secrets. Here's an example that demonstrates using dynamic credentials on each terraform apply so that no hard connection strings live in your Terraform state.

## What This Does

This example demonstrates using PostgreSQL dynamic secrets to:
- Generate temporary database credentials on each apply
- Keep sensitive credentials out of Terraform state
- Provide time-limited access for enhanced security

## Prerequisites

1. Infisical project already created (use `../project-bootstrap`)
2. PostgreSQL database with admin credentials stored in Infisical
3. Network connectivity between Infisical and your database

## Quick Start

1. **Navigate to dynamic-secrets:**
   ```bash
   cd terraform-examples/dynamic-secrets
   ```

2. **Store database admin credentials in Infisical:**
   ```bash
   # First, store admin credentials in your Infisical project
   infisical secrets set DB_ADMIN_USER=postgres --env=prod --path=/database/admin
   infisical secrets set DB_ADMIN_PASS=your-admin-password --env=prod --path=/database/admin
   ```

3. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

4. **Deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## PostgreSQL Dynamic Secret Example

This example creates a PostgreSQL dynamic secret that generates temporary read-only users:

```hcl
# Configure PostgreSQL dynamic secret
resource "infisical_dynamic_secret_sql_database" "postgres_readonly" {
  name             = "postgres-readonly-access"
  project_slug     = var.project_slug
  environment_slug = var.environment
  path             = "/database/dynamic"
  
  default_ttl = "2h"
  max_ttl     = "4h"
  
  configuration = {
    client   = "postgres"
    host     = var.postgres_host
    port     = var.postgres_port
    database = var.postgres_database
    
    # Admin credentials from Infisical
    username = data.infisical_secret.admin_user.value
    password = data.infisical_secret.admin_pass.value
    
    creation_statement = <<-EOT
      CREATE ROLE "{{username}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{username}}";
      GRANT USAGE ON SCHEMA public TO "{{username}}";
    EOT
    
    revocation_statement = <<-EOT
      DROP ROLE IF EXISTS "{{username}}";
    EOT
  }
}

# Retrieve admin credentials from Infisical
data "infisical_secret" "admin_user" {
  env_slug     = var.environment
  workspace_id = var.project_id
  secret_path  = "/database/admin"
  secret_name  = "DB_ADMIN_USER"
}

data "infisical_secret" "admin_pass" {
  env_slug     = var.environment
  workspace_id = var.project_id
  secret_path  = "/database/admin"
  secret_name  = "DB_ADMIN_PASS"
}
```

## Using Dynamic Credentials

### With Infisical CLI
```bash
# Request temporary database credentials
infisical secrets get --path=/database/dynamic --env=prod

# The response includes temporary username/password
{
  "username": "infisical-user-1234567890",
  "password": "temp-secure-password",
  "expires_at": "2024-01-01T14:00:00Z"
}
```

### With Infisical SDK (Node.js)
```javascript
const { InfisicalClient } = require("@infisical/sdk");

const client = new InfisicalClient({
  clientId: process.env.INFISICAL_CLIENT_ID,
  clientSecret: process.env.INFISICAL_CLIENT_SECRET,
});

// Request dynamic database credentials
const dbCreds = await client.createDynamicSecretLease({
  projectSlug: "my-project",
  environmentSlug: "prod",
  path: "/database/dynamic",
  dynamicSecretName: "postgres-readonly-access",
  ttl: "1h"
});

// Use with database connection
const pool = new Pool({
  host: 'your-postgres-host',
  database: 'your-database',
  user: dbCreds.username,
  password: dbCreds.password,
  port: 5432,
});
```

### With Infisical SDK (Python)
```python
from infisical import InfisicalClient
import psycopg2

client = InfisicalClient(
    client_id=os.environ["INFISICAL_CLIENT_ID"],
    client_secret=os.environ["INFISICAL_CLIENT_SECRET"]
)

# Request dynamic database credentials
db_creds = client.create_dynamic_secret_lease(
    project_slug="my-project",
    environment_slug="prod",
    path="/database/dynamic",
    dynamic_secret_name="postgres-readonly-access",
    ttl="1h"
)

# Use with database connection
conn = psycopg2.connect(
    host="your-postgres-host",
    database="your-database",
    user=db_creds["username"],
    password=db_creds["password"]
)
```

## Configuration Options

### TTL Settings
- `default_ttl` - Default lifetime for credentials (e.g., "2h", "30m")
- `max_ttl` - Maximum allowed lifetime (cannot be extended beyond this)

### Database Admin Permissions
Your admin user needs permissions to create and drop roles:
```sql
-- PostgreSQL minimum admin permissions
GRANT CREATE ON DATABASE your_database TO admin_user;
GRANT USAGE ON SCHEMA public TO admin_user;
GRANT CREATE ON SCHEMA public TO admin_user;
```

## Benefits of Dynamic Secrets

1. **No Hardcoded Credentials**: Credentials are generated on-demand
2. **Time-Limited Access**: Automatic expiration reduces security risk
3. **Audit Trail**: Every credential request is logged
4. **Clean State**: No sensitive data in Terraform state files

## Other Dynamic Secret Types

This example focuses on PostgreSQL, but Infisical supports dynamic secrets for:
- **AWS IAM**: Temporary access keys with custom policies
- **MySQL**: Database user creation and management
- **MongoDB**: Time-limited database access
- **Kubernetes**: Service account tokens

For complete documentation on all dynamic secret types, see the [Terraform provider docs](https://registry.terraform.io/providers/Infisical/infisical/latest/docs).

## Next Steps

1. **Secret Rotation**: Automate credential lifecycle with [`../secret-rotation`](../secret-rotation)
2. **Secret Syncing**: Distribute secrets to external systems with [`../secret-syncing`](../secret-syncing)