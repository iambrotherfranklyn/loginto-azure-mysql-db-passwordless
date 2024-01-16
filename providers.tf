terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #version = "=3.0.0" #This version is failing to provision KV
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {

  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}



