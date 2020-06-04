module "simple" {
  source  = "avinor/storage-account/azurerm"
  version = "2.0.0"

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