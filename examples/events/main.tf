module {
    source = "avinor/storage-account/azurerm"
    version = "1.3.0"
}

inputs {
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
            eventhub_id = "/subscription/..../eventhub-id"
        }
    ]
}