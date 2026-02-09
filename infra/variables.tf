variable "image" {
  type        = string
  description = "Container image for Cloud Run"
}

variable "service_name" {
  type        = string
  default     = "demo-cloudrun-app"
  description = "Cloud Run service name"
}