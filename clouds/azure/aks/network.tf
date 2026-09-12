resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.azure_location

  tags = local.common_tags
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  address_space       = [var.vnet_cidr]

  tags = local.common_tags
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = [var.aks_subnet_cidr]
}

resource "azurerm_subnet" "ingress_subnet" {
  name                 = var.ingress_subnet_name
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = [var.ingress_subnet_cidr]
}

resource "azurerm_network_security_group" "ingress_nsg" {
  name                = var.ingress_nsg_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name

  security_rule {
    name                       = "Allow-HTTP-From-DevTools"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.devtools_vnet_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS-From-DevTools"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.devtools_vnet_cidr
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "ingress" {
  subnet_id                 = azurerm_subnet.ingress_subnet.id
  network_security_group_id = azurerm_network_security_group.ingress_nsg.id
}