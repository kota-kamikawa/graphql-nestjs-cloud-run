variable "gcp_project_id" {}
variable "backend_app_name" {}

variable "artifact_registry_location" {
  type = string
  # https://cloud.google.com/storage/docs/locations
  description = "Artifact Registry のロケーションをどこにするか"
}

# backendアプリケーション用の Artifact Registry リポジトリ
resource "google_artifact_registry_repository" "graphql-training-backend-app" {
  provider = google-beta

  project       = var.gcp_project_id
  location      = var.artifact_registry_location
  repository_id = var.backend_app_name
  description   = "バックエンドアプリケーション"
  format        = "DOCKER"
}

