terraform {
  required_version = "~> 1.7.5"
  backend "gcs" {
    prefix = "tfstate/v1"
  }
}

variable "gcp_project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "primary_region" {
  description = "The primary region where resources will be created."
  type        = string
}

variable "cloud_run_graphql_domain" {
  description = "The Domain of the Cloud Run GraphQL service"
  type        = string
}

locals {
  backend_app_name = "graphql-training-backend-app"
}

## project ##
provider "google" {
  project = var.gcp_project_id
  region  = var.primary_region
}
provider "google-beta" {
  project = var.gcp_project_id
  region  = var.primary_region
}

# Cloud Run のデプロイで利用するArtifact Registry のリポジトリ
module "artifact-registry" {
  source                     = "./modules/artifact-registry"
  gcp_project_id             = var.gcp_project_id
  artifact_registry_location = var.primary_region
  backend_app_name           = local.backend_app_name
}

# Cloud Run Service Account
module "cloud-run" {
  source         = "./modules/cloud-run"
  gcp_project_id = var.gcp_project_id
}

# Cloud Build
# バックエンドデプロイ
module "cloud-build" {
  source                    = "./modules/cloud-build"
  gcp_project_id            = var.gcp_project_id
  region                    = var.primary_region
  cloud_run_service_account = module.cloud-run.cloud_run_app_runner_service_account
  backend_app_name          = local.backend_app_name
  github_owner              = "kota-kamikawa"
  github_app_repo_name      = "graphql-nestjs-cloud-run"
}

# Api Gateway
module "api-gateway" {
  source                   = "./modules/api-gateway"
  cloud_run_graphql_domain = var.cloud_run_graphql_domain
  gcp_project_id           = var.gcp_project_id
}
