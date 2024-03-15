variables {

  name                = "roles"
  resource_group_name = "roles-rg"
  location            = "westeurope"

  containers = [
    {
      name        = "container1"
      access_type = "private"
      role_assignments = [
        {
          principal_id         = "12345678-1234-1234-1234-123456789014"
          role_definition_name = "Storage Blob Data Reader"
        },
      ]
    },
    {
      name        = "container2"
      access_type = "private"
      role_assignments = [
        {
          principal_id         = "12345678-1234-1234-1234-123456789015"
          role_definition_name = "Storage Blob Data Reader"
        },
        {
          principal_id         = "12345678-1234-1234-1234-123456789016"
          role_definition_name = "Storage Blob Data Contributor"
        },
      ]
    },
  ]

  role_assignments = [
    {
      principal_id         = "12345678-1234-1234-1234-123456789012"
      role_definition_name = "Storage Blob Data Reader"
    },
    {
      principal_id         = "12345678-1234-1234-1234-123456789013"
      role_definition_name = "Storage Blob Data Contributor"
    },
  ]
}

run "roles" {

  command = plan

  assert {
    condition     = azurerm_role_assignment.containers["container1-12345678-1234-1234-1234-123456789014-StorageBlobDataReader"].role_definition_name == "Storage Blob Data Reader"
    error_message = "Storage Blob Data Reader role assignment not found"
  }

  assert {
    condition     = azurerm_role_assignment.containers["container2-12345678-1234-1234-1234-123456789015-StorageBlobDataReader"].role_definition_name == "Storage Blob Data Reader"
    error_message = "Storage Blob Data Reader role assignment not found"
  }

  assert {
    condition     = azurerm_role_assignment.containers["container2-12345678-1234-1234-1234-123456789016-StorageBlobDataContributor"].role_definition_name == "Storage Blob Data Contributor"
    error_message = "Storage Blob Data Contributor role assignment not found"
  }

  assert {
    condition     = azurerm_role_assignment.main["12345678-1234-1234-1234-123456789012-StorageBlobDataReader"].role_definition_name == "Storage Blob Data Reader"
    error_message = "Storage Blob Data Reader role assignment not found"
  }

  assert {
    condition     = azurerm_role_assignment.main["12345678-1234-1234-1234-123456789013-StorageBlobDataContributor"].role_definition_name == "Storage Blob Data Contributor"
    error_message = "Storage Blob Data Contributor role assignment not found"
  }
}
