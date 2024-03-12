variables {

  name                = "simple"
  exact_name          = true
  resource_group_name = "simple-rg"
  location            = "westeurope"

  containers = [
    {
      name        = "container"
      access_type = "private"
    },
  ]

  diagnostics = {
    destination   = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-rg/providers/Microsoft.OperationalInsights/workspaces/my-log-analytics"
    eventhub_name = null
    logs          = ["StorageWrite"]
    metrics       = ["all"]
  }

}

run "simple" {
  command = plan
}