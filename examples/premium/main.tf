module "premium" {
  source = "../../"

  name                = "premium"
  resource_group_name = "premium-rg"
  location            = "westeurope"

  account_tier = "Premium"
  account_kind = "BlockBlobStorage"

  containers = [
    {
      name        = "container"
      access_type = "private"
    },
  ]
}