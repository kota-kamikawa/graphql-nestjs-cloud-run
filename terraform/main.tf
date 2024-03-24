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

locals {
  backend_app_name = "graphql-training-backend-app"
}

## project ##
provider "google" {
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
