variable "github_owner" {}
variable "github_app_repo_name" {}
variable "region" {}
variable "gcp_project_id" {}
variable "backend_app_name" {}

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
  included_files = ["./**"]
  filename       = "cloudbuild.yml"
  substitutions = {
    _REGION                         = var.region
    _ARTIFACT_REPOSITORY_IMAGE_NAME = "${var.region}-docker.pkg.dev/${var.gcp_project_id}/${var.backend_app_name}/backend"
  }
}
