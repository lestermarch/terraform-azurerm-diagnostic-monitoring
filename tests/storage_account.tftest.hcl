provider "azurerm" {
  features {}
}

variables {
  location = "uksouth"
}

run "create_resource_group" {
  module {
    source = "./tests/setup/resource-group"
  }
}

run "create_storage_account" {
  module {
    source = "./tests/setup/storage-account"
  }

  variables {
    resource_group_name = run.create_resource_group.resource_group_name
  }
}

run "create_log_analytics_workspace" {
  module {
    source = "./tests/setup/log-analytics-workspace"
  }

  variables {
    resource_group_name = run.create_resource_group.resource_group_name
  }
}

run "create_diagnostic_monitoring" {
  command = apply

  variables {
    log_analytics_workspace_id = run.create_log_analytics_workspace.log_analytics_workspace_id
    resources = {
      storage_account = {
        resource_id = run.create_storage_account.storage_account_id
      }
      storage_account_blob = {
        resource_id = "${run.create_storage_account.storage_account_id}/blobServices/default"
      }
      storage_account_file = {
        resource_id = "${run.create_storage_account.storage_account_id}/fileServices/default"
      }
      storage_account_queue = {
        resource_id = "${run.create_storage_account.storage_account_id}/queueServices/default"
      }
      storage_account_table = {
        resource_id = "${run.create_storage_account.storage_account_id}/tableServices/default"
      }
    }
  }
}
