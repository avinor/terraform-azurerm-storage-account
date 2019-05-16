module "simple" {
    source = "../../"

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
                subject_begins_with = ""
            }
            eventhub_id = ""
        }
    ]
}