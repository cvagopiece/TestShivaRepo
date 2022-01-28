terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = "7fbdb866-116a-4a58-98a1-d3b66f0b32a8"
  tenant_id         = "28b74379-9949-4c32-8a25-49fbdaaf30fc"
  client_id         = "b7709e84-50ee-4f19-9db8-d1e0598f69ec"
  client_secret     = "m4.7Q~D7fpDiDpU_bg5vD_hpdBo0Q.w2pZH1J"
}


data "azurerm_client_config" "current" {}

# Create a resource group
resource "azurerm_resource_group" "dev-rg" {
  name     = "dev-environment-rg"
  location = "eastus"
}

# Create app service plan
resource "azurerm_app_service_plan" "service-plan" {
  name = "simple-service-plan"
  location = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  kind = "Linux"
  reserved = true
  sku {
    tier = "Standard"
    size = "S1"
  }
  tags = {
    environment = "dev"
  }
}

# Create JAVA app service
resource "azurerm_app_service" "app-service" {
  name = "my-sgm-app-svc"
  location = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  app_service_plan_id = azurerm_app_service_plan.service-plan.id

site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
tags = {
    environment = "dev"
  }
}