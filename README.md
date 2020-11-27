# Storage account

Module to create an Azure storage account with set of containers (and access level). Storage account will enable encryption of file and blob and require https, these options are not possible to change. It is recommended to set the network policies to restrict access to account.

To enable advanced threat procetion set the variable `enable_advanced_threat_protection` to true.

To disable soft delete set `soft_delete_retention` to `null`. Otherwise set it to the number of retention days, default is 31.

## Usage

To just create a storage account with some containers have a look at the simple example. Examples use [tau](https://github.com/avinor/tau).

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
        },
    ]
}
```

## Events

It is also possible to connect Event Grid subscriptions to storage account and send event to an Event Hub or a ServiceBus. 
This requires the `events` variable to be set. 
Since variable object doesn´t support optional properties it uses `any` instead.
NB! One of eventhub_id, service_bus_topic_id or service_bus_queue_id must be set.  
The input object looks like this:

```terraform
events = [
    {
        name = required
        event_delivery_schema = optional(string)
        labels = optional(list(string))
        eventhub_id = optional(string)
        service_bus_topic_id = optional(string)
        service_bus_queue_id = optional(string)
        included_event_types = optional(list(string))

        filters = optional({
            subject_begins_with = optional(string)
            subject_ends_with = optional(string)
        })
    }
]
```

Example usage:

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
        },
    ]

    # Send all events to event hub
    events = [
        {
            name = "send_to_eventhub"
            eventhub_id = "/subscriptions/xxxx-xxxx-xxxx-xxxx/..../eventhub-id"
        }
    ]
}
```

## Management Policy

Manages an Azure Storage Account Lifecycle Management.

```terraform
lifecycles = [
    {
        prefix_match = required (list(string))
        delete_after_days = required (number)
    }
]
```

Example usage:

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
    # Add lifecycles
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
