# Storage account lifecycle management example

This example creates a simple storage account with lifecycle management.

Using example with [tau](https://github.com/avinor/tau) 

```terraform
module {
    source = "avinor/storage-account/azurerm"
    version = "2.0.0"
}
inputs {
    name = "simple"
    resource_group_name = "simple-rg"
    location = "westeurope"
    containers = [
        {
            name = "container"
            access_type = "private"
        }
    ]
    lifecycles = [
        {
            prefix_match = ["container/path"]
            delete_after_days = 2
        },
        {
            prefix_match = ["container/another_path"]
            delete_after_days = 5
        }
    ]
}
```
