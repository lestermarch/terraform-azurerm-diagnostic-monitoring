# Azure Diagnostic Monitoring
This module allows for the enablement of diagnostic logging to a log analytics workspace for multiple resources. By default, resources will have all log and metric categories forwarded, but these can be fine-tuned on a per-resource basis.

## Examples

1. [TODO]

```hcl
module {
  source  = "lestermarch/diagnostic-monitoring/azurerm"
  version = "1.0.0"

  location            = "uksouth"
  resource_group_name = "rg-example"

  ...
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
| <a name="input_resources"></a> [resources](#input\_resources) | A list of objects used to forward diagnostic logs and metrics to a log analytics workspace for one or more resources, in the format:<pre>hcl<br>[<br>  {<br>    resource_id = "/subscriptions/.../storageAccounts/stexample"<br>  },<br>  {<br>    resource_id = "/subscriptions/.../vaults/kv-example"<br>    metric_categories = [<br>      "Availability",<br>      "SaturationShoebox",<br>      "ServiceApiLatency"<br>    ]<br>  }<br>]</pre>Notes:<br>- All log categories will be enabled unless `log_categories` | <pre>list(object({<br>    resource_id       = string<br>    log_categories    = optional(list(string))<br>    metric_categories = optional(list(string))<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
