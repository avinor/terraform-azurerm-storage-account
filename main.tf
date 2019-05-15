terraform {
  required_version = ">= 0.12.0"
  backend "azurerm" {}
}

resource "azurerm_resource_group" "logs" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

