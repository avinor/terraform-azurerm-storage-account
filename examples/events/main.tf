module "simple" {
  source = "../../"

  name                = "simple"
  resource_group_name = "simple-rg"
  location            = "westeurope"

  containers = [
    {
      name        = "container"
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