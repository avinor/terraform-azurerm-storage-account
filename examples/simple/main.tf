module "simple" {
    source = "avinor/storage-account/azurerm"
    version = "1.3.0"
    
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