terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.93.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cst8918_iac_h9" {
  name     = "cst8918_iac_h9"
  location = "Canada Central"
}

resource "azurerm_kubernetes_cluster" "abdoakscluster" {
  name                = "abdoakscluster"
  resource_group_name = azurerm_resource_group.cst8918_iac_h9.name
  location            = azurerm_resource_group.cst8918_iac_h9.location
  dns_prefix          = "hybridaksdns"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_B2s"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "prod"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.abdoakscluster.kube_config_raw
  sensitive = true
}
