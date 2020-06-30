# Configure the Providers
provider "azurerm" {
    features {}
}

resource "random_pet" "red_team" {}

resource "random_pet" "blue_team" {}
