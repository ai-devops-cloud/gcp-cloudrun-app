terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "ai-kida"

    workspaces {
      name = "gcp-cloudrun-app"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}