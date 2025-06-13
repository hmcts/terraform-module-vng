resource "azurerm_subnet" "gateway_subnet" {
  count = var.create_gateway_subnet ? 1 : 0

  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_public_ip" "gateway_ip" {
  count = var.create_public_ip ? 1 : 0

  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
}
