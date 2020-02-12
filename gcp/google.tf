variable "project" {
  type = string
  description = "Google Cloud project name"
}

variable "region" {
  type = string
  description = "Default Google Cloud region"
}

provider "google" {
  credentials = file("../secrets/account.json")
  project     = var.project
  region      = var.region
}

