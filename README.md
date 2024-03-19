# Azure Diagnostic Monitoring
This module allows for the enablement of diagnostic logging to a log analytics workspace for multiple resources. By default, resources will have all log and metric categories forwarded, but these can be fine-tuned on a per-resource basis.

## Examples

1. Single resource, all log and metric categories:

```hcl
module {
  source  = "lestermarch/diagnostic-monitoring/azurerm"
  version = "1.0.0"

  location            = "uksouth"
  resource_group_name = "rg-example"

  log_analytics_workspace = "/subscriptions/.../workspaces/log-example"
  resources = {
    stexample = {
      resource_id = "/subscriptions/.../storageAccounts/stexample"
    }
  }
}
```

2. Multiple resources, all log categories, custom metric categories:

```hcl
module {
  source  = "lestermarch/diagnostic-monitoring/azurerm"
  version = "1.0.0"

  location            = "uksouth"
  resource_group_name = "rg-example"

  log_analytics_workspace = "/subscriptions/.../workspaces/log-example"
  resources = {
    stexample = {
      resource_id = "/subscriptions/.../storageAccounts/stexample"
    },
    kv-example = {
      resource_id = "/subscriptions/.../vaults/kv-example"
      metric_categories = [
        "Availability",
        "SaturationShoebox",
        "ServiceApiLatency"
      ]
    }
  }
}
```

3. Storage subresource metrics:

```hcl
module {
  source  = "lestermarch/diagnostic-monitoring/azurerm"
  version = "1.0.0"

  location            = "uksouth"
  resource_group_name = "rg-example"

  log_analytics_workspace = "/subscriptions/.../workspaces/log-example"
  resources = {
    stexample = {
      resource_id = "/subscriptions/.../storageAccounts/stexample"
    }
    stexample_blob = {
      resource_id = "${/subscriptions/.../storageAccounts/stexample}/blobServices/default"
    }
  }
}
```

The following suffixes may be added to a storage account resource ID to enable monitoring for the respective subresource:

| Subresource | Suffix                 |
| ----------- | ---------------------- |
| Blob        | /blobServices/default  |
| File        | /fileServices/default  |
| Queue       | /queueServices/default |
| Table       | /tableServices/default |

4. Diagnostic monitoring configuration from YAML (or JSON):

```yaml
# Storage account "stexample1" with all logs enabled:
stexample1:
  resource_id: "/subscriptions/.../storageAccounts/stexample2"

# Key vault "kv-example" with custom
kv-example:
  resource_id: "/subscriptions/.../vaults/kv-example"
  metric_categories:
    - "Availability"
    - "SaturationShoebox"
    - "ServiceApiLatency"

# Storage account "stexample2" with custom blob log categories:
stexample2:
  resource_id: "/subscriptions/.../storageAccounts/stexample2"
  storage_blob_log_categories:
    - "StorageWrite"
    - "StorageDelete"
```

```hcl
module {
  source  = "lestermarch/diagnostic-monitoring/azurerm"
  version = "1.0.0"

  location            = "uksouth"
  resource_group_name = "rg-example"

  log_analytics_workspace = "/subscriptions/.../workspaces/log-example"
  resources               = yamldecode(file("${path.module}/config/diagnostic-monitoring.yaml"))

  # For JSON:
  # endpoints = jsondecode(file("${path.module}/config/diagnostic-monitoring.json"))
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.95.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of a log analytics workspace to forward network interface metrics to. | `string` | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | A map of objects used to forward diagnostic logs and metrics to a log analytics workspace for one or more resources, in the format:<pre>{<br>  stexample = {<br>    resource_id = "/subscriptions/.../storageAccounts/stexample"<br>  },<br>  kv-example = {<br>    resource_id = "/subscriptions/.../vaults/kv-example"<br>    metric_categories = [<br>      "Availability",<br>      "SaturationShoebox",<br>      "ServiceApiLatency"<br>    ]<br>  }<br>}</pre>Notes:<br>- Each endpoint object must have a unique map key and must be statically defined. It is recommended to use the resource name for this, if known.<br>- All log categories will be enabled unless `log_categories` is specified.<br>- All metric categories will be enbled unless `metric_categories` is specified. | <pre>map(object({<br>    resource_id       = string<br>    log_categories    = optional(list(string))<br>    metric_categories = optional(list(string))<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
