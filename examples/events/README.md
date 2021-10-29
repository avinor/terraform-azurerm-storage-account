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
          name                 = "send-to-eventhub"
          eventhub_id          = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-rg/providers/Microsoft.EventHub/namespaces/events-ns/eventhubs/my-events"
          service_bus_topic_id = null
          included_event_types = ["Microsoft.Storage.BlobCreated", "Microsoft.Storage.BlobDeleted"]
          filters = {
            subject_begins_with = "test"
          }
        },
        {
          name                 = "send-to-servicebus-topic"
          eventhub_id          = null
          service_bus_topic_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-rg/providers/Microsoft.ServiceBus/namespaces/servicebus-sbn/topics/my-topic"
          included_event_types = ["Microsoft.Storage.BlobCreated"]
          filters = {
            subject_begins_with = "test"
          }
        }
      ]
}
```
