variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "autralia-southeast1"
}

provider "google" {
  project = var.project_id
  region  = var.region
}