# Enable APIs
resource "google_project_service" "run" {
  project = var.project_id
  service = "run.googleapis.com"
}

resource "google_project_service" "artifactregistry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
}

# Service account for Cloud Run
resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-demo-sa"
  display_name = "Cloud Run demo service account"
}

# (Optional) Allow this SA to pull Artifact Registry images if needed
resource "google_project_iam_member" "artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# Cloud Run service
resource "google_cloud_run_service" "app" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.cloud_run_sa.email

      containers {
        image = var.image

        ports {
          name           = "http1"
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.run,
    google_project_service.artifactregistry,
  ]
}

# Allow unauthenticated access
resource "google_cloud_run_service_iam_member" "invoker" {
  location = google_cloud_run_service.app.location
  project  = var.project_id
  service  = google_cloud_run_service.app.name

  role   = "roles/run.invoker"
  member = "allUsers"
}