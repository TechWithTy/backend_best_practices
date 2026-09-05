# Ephemeral retrieval - secrets never touch state file!
ephemeral "infisical_secret" "database_url" {
  name         = "DATABASE_URL"
  workspace_id = infisical_project.main.id
  env_slug     = "prod"
  folder_path  = "/database"
}

ephemeral "infisical_secret" "api_key" {
  name         = "STRIPE_KEY"
  workspace_id = infisical_project.main.id
  env_slug     = "prod"
  folder_path  = "/api"
}

ephemeral "infisical_secret" "jwt_secret" {
  name         = "JWT_SECRET"
  workspace_id = infisical_project.main.id
  env_slug     = "prod"
  folder_path  = "/api"
}

# Use with AWS Lambda
resource "aws_lambda_function" "api" {
  count = var.create_aws_resources ? 1 : 0
  
  function_name = "${var.project_name}-api"
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  filename      = "lambda.zip"
  
  environment {
    variables = {
      DATABASE_URL = ephemeral.infisical_secret.database_url.value
      STRIPE_KEY   = ephemeral.infisical_secret.api_key.value
      JWT_SECRET   = ephemeral.infisical_secret.jwt_secret.value
    }
  }
}

# Use with Kubernetes
resource "kubernetes_secret" "app_secrets" {
  count = var.create_kubernetes_resources ? 1 : 0
  
  metadata {
    name      = "${var.project_name}-secrets"
    namespace = "default"
  }
  
  data = {
    DATABASE_URL = ephemeral.infisical_secret.database_url.value
    STRIPE_KEY   = ephemeral.infisical_secret.api_key.value
    JWT_SECRET   = ephemeral.infisical_secret.jwt_secret.value
  }
}

# Use with Docker/ECS
resource "aws_ecs_task_definition" "app" {
  count = var.create_aws_resources ? 1 : 0
  
  family = var.project_name
  
  container_definitions = jsonencode([
    {
      name  = "app"
      image = "${var.project_name}:latest"
      
      environment = [
        {
          name  = "DATABASE_URL"
          value = ephemeral.infisical_secret.database_url.value
        },
        {
          name  = "STRIPE_KEY"
          value = ephemeral.infisical_secret.api_key.value
        },
        {
          name  = "JWT_SECRET"
          value = ephemeral.infisical_secret.jwt_secret.value
        }
      ]
    }
  ])
}