locals {
  common_tags = {
    environment = var.environment
    low         = "banking"
    stage       = "alpha"
  }
}