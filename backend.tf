terraform {
  backend "gcs" {
    bucket = "terraform-tfstate-hamza"
    prefix = "terraform/state"
  }
}

