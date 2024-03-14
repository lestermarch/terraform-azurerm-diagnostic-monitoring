locals {
  # Generate resource names unless otherwise specified
  resource_name = {
    log_analytics_workspace = "log-${local.resource_suffix}"
  }

  # Randomised resource suffix to use for generated resource names
  resource_suffix = "${random_pet.resource_suffix.id}-${random_integer.entropy.result}"
}
