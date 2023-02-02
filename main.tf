# Resource Group
resource "azurerm_resource_group" "rgtestcore" {
  name     = local.rg_name
  location = local.azure_region

  tags = local.common_tags
}

# VNET
resource "azurerm_virtual_network" "vnettestcore" {
  name                = local.vnet_name
  resource_group_name = local.rg_name
  location            = local.azure_region

  address_space = ["10.0.0.0/20"]

  tags = local.common_tags
}

# Subnet of the VNET - Can in Inline with VNET Block
resource "azurerm_subnet" "snet_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rgtestcore.name
  virtual_network_name = azurerm_virtual_network.vnettestcore.name

  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "snet_compute" {
  name                 = "snet-compute-${var.azure_region}-${var.instance}"
  resource_group_name  = azurerm_resource_group.rgtestcore.name
  virtual_network_name = azurerm_virtual_network.vnettestcore.name

  address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "piptestgw" {
  name                = "pip-vnet-gateway-${var.environment}-${var.azure_region}-${var.instance}"
  resource_group_name = azurerm_resource_group.rgtestcore.name
  location            = local.azure_region

  allocation_method = "Dynamic"

  tags = local.common_tags
}

resource "azurerm_virtual_network_gateway" "vgwtestvpn" {
  name                = local.vgw_name
  location            = local.azure_region
  resource_group_name = azurerm_resource_group.rgtestcore.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2"
  generation    = "Generation2"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.piptestgw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.snet_gateway.id
  }

  tags = local.common_tags
}

resource "azurerm_local_network_gateway" "lgwtestonpremise" {
  name                = "lgw-onpremise-${var.azure_region}-${var.instance}"
  resource_group_name = azurerm_resource_group.rgtestcore.name
  location            = azurerm_resource_group.rgtestcore.location

  gateway_address = local.onpremise_gw
  address_space   = [ local.onpremise_addresses ]
  tags            = local.common_tags

}

resource "azurerm_virtual_network_gateway_connection" "cntestonpremise" {
  name                = "cn-${azurerm_local_network_gateway.lgwtestonpremise.name}-to-${azurerm_virtual_network_gateway.vgwtestvpn.name}"
  location            = azurerm_resource_group.rgtestcore.location
  resource_group_name = azurerm_resource_group.rgtestcore.name

  type                = "IPsec"
  connection_protocol = "IKEv2"

  virtual_network_gateway_id = azurerm_virtual_network_gateway.vgwtestvpn.id
  local_network_gateway_id   = azurerm_local_network_gateway.lgwtestonpremise.id

  shared_key = local.ipsec_shared_key
}