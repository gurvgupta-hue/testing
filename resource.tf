terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-secure-storage-demo"
  location = "East US"
}

resource "azurerm_storage_account" "secure" {
  name                     = "securestoragedemo1234"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = true
  public_network_access_enabled   = true

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    environment = "demo"
    security    = "hardened"
  }
}

resource "azurerm_storage_container" "private" {
  name                  = "private-data"
  storage_account_name  = azurerm_storage_account.secure.name
  container_access_type = "private"
}
