variables {

  name                = "premium"
  resource_group_name = "premium-rg"
  location            = "westeurope"

  account_tier = "Premium"
  account_kind = "BlobStorage"

  containers = [
    {
      name        = "container"
      access_type = "private"
    },
  ]

}

run "simple" {
  command = plan
}