
variable "cloud_run_graphql_domain" {
  description = "The Domain of the Cloud Run GraphQL service"
  type        = string
}

variable "gcp_project_id" {
  description = "GCPのproject_idです"
  type        = string
}

resource "google_api_gateway_api" "graphql" {
  provider = google-beta
  api_id   = "graphql"
}

resource "google_service_account" "api_gateway_account" {
  project      = var.gcp_project_id
  account_id   = "apigw-sa"
  display_name = "API Gateway Service Account"
}

resource "google_project_iam_member" "api_gateway_invoker" {
  project = var.gcp_project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.api_gateway_account.email}"
}

resource "google_api_gateway_api_config" "graphql_config_auth" {
  provider      = google-beta
  api           = google_api_gateway_api.graphql.api_id
  api_config_id = "graphql-config-auth"

  openapi_documents {
    document {
      path = "openapi2-run.yaml"
      contents = base64encode(templatefile("${path.module}/openapi2-run.yaml.tpl", {
        # プレースホルダーに値を挿入
        cloud_run_graphql_domain = var.cloud_run_graphql_domain
        gcp_project_id           = var.gcp_project_id
      }))
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  gateway_config {
    backend_config {
      google_service_account = google_service_account.api_gateway_account.email
    }
  }
}

resource "google_api_gateway_gateway" "api_gw" {
  provider   = google-beta
  api_config = google_api_gateway_api_config.graphql_config_auth.id
  gateway_id = "graphql-gateway"
  depends_on = [
    google_api_gateway_api_config.graphql_config_auth
  ]
}
