# main.tf

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=4.2.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "e418836a-4bbc-48c9-9b94-9fa9ad0ca7de"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-appinnovghdemo"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage" {
  name                     = "appinnovghdemostorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "asp" {
  name                = "appinnovghdemo-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "appinnovghdemo-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
        dotnet_version = "8.0"
    }
  }
    
}