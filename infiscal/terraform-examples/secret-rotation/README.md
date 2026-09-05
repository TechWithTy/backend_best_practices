# Secret Rotation

**ENTERPRISE FEATURE** - Automate credential lifecycle management with scheduled rotation for databases, cloud providers, and other services.

## Enterprise-Grade Feature

**This is designed for enterprise environments with:**
- Dedicated database administrators
- Formal change management processes  
- 24/7 operational requirements
- Compliance mandates for credential rotation
- **Most teams should start with static secrets and manual rotation**

## What This Does

- Configures automatic rotation for MySQL and PostgreSQL database credentials
- Sets up AWS IAM access key rotation
- Manages Azure client secret rotation
- Implements zero-downtime rotation with dual user patterns
- Schedules rotations at specific times and intervals

## Prerequisites (Enterprise Setup)

1. **Infisical project** already created (use [`../project-bootstrap`](../project-bootstrap))
2. **Pre-created database users** - Primary and secondary users must exist in your database
3. **Admin database access** - Connection credentials need user management permissions
4. **Change management approval** - Coordinate rotation schedules with your team
5. **Monitoring setup** - Track rotation success/failure in production

**For simpler needs, consider manual rotation of static secrets first.**

## Quick Start

1. **Navigate to secret-rotation:**
   ```bash
   cd terraform-examples/secret-rotation
   ```

2. **Prepare database users (if using database rotation):**
   ```sql
   -- MySQL
   CREATE USER 'app_user_primary'@'%' IDENTIFIED BY 'initial-password-1';
   CREATE USER 'app_user_secondary'@'%' IDENTIFIED BY 'initial-password-2';
   GRANT ALL PRIVILEGES ON myapp.* TO 'app_user_primary'@'%';
   GRANT ALL PRIVILEGES ON myapp.* TO 'app_user_secondary'@'%';
   
   -- PostgreSQL
   CREATE USER app_user_primary WITH LOGIN PASSWORD 'initial-password-1';
   CREATE USER app_user_secondary WITH LOGIN PASSWORD 'initial-password-2';
   GRANT ALL PRIVILEGES ON DATABASE myapp TO app_user_primary;
   GRANT ALL PRIVILEGES ON DATABASE myapp TO app_user_secondary;
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

## Rotation Patterns

### 1. MySQL Credential Rotation

Uses a dual-user pattern for zero-downtime rotation:

```hcl
resource "infisical_secret_rotation_mysql_credentials" "app_users" {
  name          = "mysql-app-user-rotation"
  project_id    = var.project_id
  environment   = "prod"
  secret_path   = "/database/mysql"
  connection_id = var.mysql_connection_id
  
  parameters = {
    username1 = "app_user_primary"    # Must exist in database
    username2 = "app_user_secondary"  # Must exist in database
  }
  
  secrets_mapping = {
    username = "MYSQL_USERNAME"  # Active username secret
    password = "MYSQL_PASSWORD"  # Active password secret
  }
  
  auto_rotation_enabled = true
  rotation_interval     = 30  # days
  
  rotate_at_utc = {
    hours   = 2   # 2 AM UTC
    minutes = 0
  }
}
```

**How it works:**
1. Two database users exist (primary and secondary)
2. Application uses the "active" credentials (MYSQL_USERNAME/MYSQL_PASSWORD)
3. During rotation:
   - Inactive user's password is changed
   - Active secrets are switched to the inactive user
   - Previous active user becomes inactive for next rotation
4. Zero downtime as connections using old credentials remain valid

### 2. AWS IAM Access Key Rotation

Rotates IAM user access keys:

```hcl
resource "infisical_secret_rotation_aws_iam_user_secret" "iam_user" {
  name          = "aws-iam-user-secret-rotation"
  project_id    = var.project_id
  environment   = "prod"
  secret_path   = "/aws/iam"
  connection_id = var.aws_connection_id
  
  parameters = {
    user_name = "app-user"
    region    = "us-east-1"
  }
  
  secrets_mapping = {
    access_key_id     = "AWS_ACCESS_KEY_ID"
    secret_access_key = "AWS_SECRET_ACCESS_KEY"
  }
  
  auto_rotation_enabled = true
  rotation_interval     = 30  # days
  
  rotate_at_utc = {
    hours   = 3
    minutes = 0
  }
}
```

**How it works:**
1. IAM user can have up to 2 access keys
2. During rotation:
   - New access key is created
   - Secrets are updated with new key
   - Old access key is deleted after grace period
3. Applications automatically get new credentials

### 3. PostgreSQL Credential Rotation

Similar to MySQL with dual-user pattern:

```hcl
resource "infisical_secret_rotation_postgres_credentials" "app_users" {
  name          = "postgres-app-user-rotation"
  project_id    = var.project_id
  environment   = "prod"
  secret_path   = "/database/postgres"
  connection_id = var.postgres_connection_id
  
  parameters = {
    username1 = "app_user_primary"
    username2 = "app_user_secondary"
  }
  
  secrets_mapping = {
    username = "POSTGRES_USERNAME"
    password = "POSTGRES_PASSWORD"
  }
  
  auto_rotation_enabled = true
  rotation_interval     = 30
}
```

### 4. Azure Client Secret Rotation

Rotates Azure AD application client secrets:

```hcl
resource "infisical_secret_rotation_azure_client_secret" "app_client" {
  name          = "azure-client-secret-rotation"
  project_id    = var.project_id
  environment   = "prod"
  secret_path   = "/azure"
  connection_id = var.azure_connection_id
  
  parameters = {
    object_id = "app-object-id"
    client_id = "app-client-id"
  }
  
  secrets_mapping = {
    client_id     = "AZURE_CLIENT_ID"
    client_secret = "AZURE_CLIENT_SECRET"
  }
  
  auto_rotation_enabled = true
  rotation_interval     = 30
}
```

## Database User Setup

### MySQL Prerequisites
```sql
-- Create admin user for rotation operations
CREATE USER 'rotation_admin'@'%' IDENTIFIED BY 'secure-password';
GRANT ALL PRIVILEGES ON *.* TO 'rotation_admin'@'%' WITH GRANT OPTION;

-- Create application users
CREATE USER 'app_user_primary'@'%' IDENTIFIED BY 'initial-password-1';
CREATE USER 'app_user_secondary'@'%' IDENTIFIED BY 'initial-password-2';

-- Grant application permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON myapp.* TO 'app_user_primary'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON myapp.* TO 'app_user_secondary'@'%';

FLUSH PRIVILEGES;
```

### PostgreSQL Prerequisites
```sql
-- Create application users
CREATE USER app_user_primary WITH LOGIN PASSWORD 'initial-password-1';
CREATE USER app_user_secondary WITH LOGIN PASSWORD 'initial-password-2';

-- Grant permissions
GRANT CONNECT ON DATABASE myapp TO app_user_primary;
GRANT CONNECT ON DATABASE myapp TO app_user_secondary;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_user_primary;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_user_secondary;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO app_user_primary;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO app_user_secondary;

-- Allow password changes
ALTER USER app_user_primary CREATEROLE;
ALTER USER app_user_secondary CREATEROLE;
```

## Rotation Configuration

### Scheduling
```hcl
rotation_interval = 30  # Days between rotations

rotate_at_utc = {
  hours   = 2   # Hour (0-23)
  minutes = 0   # Minutes (0-59)
}
```

### Manual Rotation
Trigger immediate rotation via Infisical UI or API:
```bash
# Using Infisical CLI
infisical rotation trigger --rotation-id=<rotation-id>
```

### Monitoring Rotations
Check rotation status and history:
```bash
# View rotation logs
infisical rotation logs --project=<project-id>

# Get rotation status
infisical rotation status --rotation-id=<rotation-id>
```

## Application Integration

### Zero-Downtime Pattern
```javascript
// Node.js example with connection pooling
const mysql = require('mysql2');
const { InfisicalClient } = require('@infisical/sdk');

const client = new InfisicalClient({
  clientId: process.env.INFISICAL_CLIENT_ID,
  clientSecret: process.env.INFISICAL_CLIENT_SECRET,
});

let pool;

async function getConnection() {
  const secrets = await client.getSecret({
    projectId: 'project-id',
    environment: 'prod',
    path: '/database/mysql',
    secrets: ['MYSQL_USERNAME', 'MYSQL_PASSWORD']
  });
  
  if (!pool) {
    pool = mysql.createPool({
      host: 'mysql.example.com',
      user: secrets.MYSQL_USERNAME,
      password: secrets.MYSQL_PASSWORD,
      database: 'myapp',
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0
    });
  }
  
  return pool;
}

// Refresh credentials periodically
setInterval(async () => {
  try {
    const newPool = await getConnection();
    const oldPool = pool;
    pool = newPool;
    
    // Gracefully close old connections
    if (oldPool) {
      setTimeout(() => oldPool.end(), 60000); // 1 minute grace period
    }
  } catch (error) {
    console.error('Failed to refresh credentials:', error);
  }
}, 3600000); // Refresh every hour
```

## Best Practices

### Security
- Use separate admin credentials for rotation operations
- Implement least-privilege for rotation service accounts
- Enable SSL/TLS for all database connections
- Monitor rotation failures and alerts
- Test rotation in non-production first

### Operations
- Schedule rotations during low-traffic periods
- Implement connection pooling with credential refresh
- Set up monitoring for rotation failures
- Document rotation procedures and rollback plans
- Test application behavior during rotation

### Rotation Intervals
- **High Security**: 7-14 days
- **Standard**: 30 days
- **Compliance**: As required (e.g., 90 days for PCI DSS)
- **Development**: 90 days or manual

## Troubleshooting

### Common Issues

1. **Rotation Failed - Permission Denied**
   ```sql
   -- Check MySQL permissions
   SHOW GRANTS FOR 'rotation_admin'@'%';
   
   -- Check PostgreSQL permissions
   \du app_user_primary
   ```

2. **Application Connection Errors During Rotation**
   - Implement connection retry logic
   - Use connection pooling with refresh
   - Increase grace period for old credentials

3. **AWS IAM Key Limit Reached**
   ```bash
   # List existing access keys
   aws iam list-access-keys --user-name app-user
   
   # Delete old keys manually if needed
   aws iam delete-access-key --user-name app-user --access-key-id OLD_KEY_ID
   ```

4. **Database User Locked**
   ```sql
   -- MySQL: Unlock user
   ALTER USER 'app_user_primary'@'%' ACCOUNT UNLOCK;
   
   -- PostgreSQL: Reset password manually
   ALTER USER app_user_primary WITH PASSWORD 'new-password';
   ```

### Monitoring Rotation Health

Create alerts for:
- Rotation failures
- Credentials approaching expiration
- Abnormal rotation duration
- Connection errors post-rotation

## Rollback Procedures

### Manual Password Reset
```sql
-- MySQL
ALTER USER 'app_user_primary'@'%' IDENTIFIED BY 'emergency-password';
FLUSH PRIVILEGES;

-- PostgreSQL
ALTER USER app_user_primary WITH PASSWORD 'emergency-password';
```

### Disable Rotation
```hcl
# Set in terraform.tfvars
mysql_auto_rotation_enabled = false

# Apply changes
terraform apply
```

### Restore Previous Credentials
```bash
# Use Infisical secret history
infisical secrets rollback --secret=MYSQL_PASSWORD --version=<previous-version>
```

## Next Steps

1. **Secret Syncing**: Sync rotated credentials to external stores with [`../secret-syncing`](../secret-syncing)
2. **Static Secrets**: For simpler use cases, see [`../static-secrets`](../static-secrets)
3. **Dynamic Secrets**: Generate temporary credentials with [`../dynamic-secrets`](../dynamic-secrets)