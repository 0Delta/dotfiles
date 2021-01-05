provider "google" {
  project = "{{_input_:projectID}}"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-c"
}

terraform {
  backend "gcs" {
    bucket = "tf-state-prod"
    prefix = "terraform/state"
  }
}
