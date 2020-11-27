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

  lifecycles = [
    {
      prefix_match      = ["container/path"]
      delete_after_days = 2
    },
    {
      prefix_match      = ["container/another_path"]
      delete_after_days = 5
    }
  ]
}