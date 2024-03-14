variable "location" {
  description = "The primary region into which resources will be deployed."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of a log analytics workspace to forward network interface metrics to."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group into which resources will be deployed."
  type        = string
}

variable "resource_tags" {
  default     = {}
  description = "A map of key/value pairs to be assigned as resource tags on taggable resources."
  type        = map(string)
}
