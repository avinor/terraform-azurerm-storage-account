variables {

  name                = "simple"
  resource_group_name = "simple-rg"
  location            = "westeurope"

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