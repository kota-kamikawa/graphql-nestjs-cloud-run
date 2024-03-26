variable "github_owner" {}
variable "github_app_repo_name" {}
variable "region" {}
variable "gcp_project_id" {}
variable "backend_app_name" {}
variable "cloud_run_service_account" {}

resource "google_cloudbuild_trigger" "graphql-training-backend-app" {
  name        = "graphql-training-backend-app"
  description = "NestJSアプリを Cloud Run へdeployする"
  github {
    owner = var.github_owner
    name  = var.github_app_repo_name
    push {
      branch = "^main$"
    }
  }
  #   included_files = ["src/**"]
  filename = "cloudbuild.yml"
  substitutions = {
    _REGION                         = var.region
    _SERVICE_ACCOUNT                = var.cloud_run_service_account
    _ARTIFACT_REPOSITORY_IMAGE_NAME = "${var.region}-docker.pkg.dev/${var.gcp_project_id}/${var.backend_app_name}/backend"
  }
}
