provider "aws" {
  alias   = "secops"
  profile = var.secops-profile
  region  = var.region
}