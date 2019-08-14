# Storage account events example

This example creates a simple storage account that send events to an eventhub when blobs are created / updated. It requires the id of event hub as input. Event hub can be created with the `avinor/event-hubs/azurerm` module.

Using example with [tau](https://github.com/avinor/tau) the eventhub id can be retrieved from a dependency.

```terraform
dependency "eventhub" {
    source = "./hub.hcl"
}

module {
    source = "avinor/storage-account/azurerm"
    version = "1.3.0"
}

inputs {
    name = "simple"
    resource_group_name = "simple-rg"
    location = "westeurope"

    containers = [
        {
            name = "container"
            access_type = "private"
        },
    ]

    events = [
        {
            name = "send_to_eventhub"
            filters = {
                subject_begins_with = "test"
            }
            eventhub_id = dependency.eventhub.outputs.id
        }
    ]
}
```
