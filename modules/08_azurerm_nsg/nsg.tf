resource "azurerm_network_security_group" "mi-nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "nsg-rule" {

  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"          # you can restrict this to your IP for better security
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.mi-nsg.name
}


resource "azurerm_subnet_network_security_group_association" "mi-nsg-association" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.mi-nsg.id
}