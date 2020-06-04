# Storage account events example

This example creates a simple storage account that send events to an eventhub when blobs are created / updated. It requires the id of event hub as input. Event hub can be created with the `avinor/event-hubs/azurerm` module.

Using example with [tau](https://github.com/avinor/tau) the eventhub id can be retrieved from a dependency.

```terraform
dependency "eventhub" {
    source = "./hub.hcl"
}

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
        },
    ]

    events = [
        {
          name                 = "send_to_eventhub"
          eventhub_id          = "/subscription/..../eventhub-id"
          service_bus_topic_id = null
          included_event_types = ["Microsoft.Storage.BlobCreated", "Microsoft.Storage.BlobDeleted"]
          filters = {
            subject_begins_with = "test"
          }
        },
        {
          name                 = "send_to_servicebus_topic"
          eventhub_id          = null
          service_bus_topic_id = "/subscription/..../topic-id"
          included_event_types = ["Microsoft.Storage.BlobCreated"]
          filters = {
            subject_begins_with = "test"
          }
        }
      ]
}
```
