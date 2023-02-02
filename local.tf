

# Local Values Block

locals {
  rg_name   = "rg-${var.workload}-${var.environment}-${var.azure_region}-${var.instance}"
  vnet_name = "vnet-${var.workload}-${var.environment}-${var.azure_region}-${var.instance}"
  vgw_name  = "vgw-${var.workload}-${var.environment}-${var.azure_region}-${var.instance}"

  azure_region = var.azure_region

  onpremise_gw        = var.onpremise_gateway_address
  onpremise_addresses = var.onpremise_address_space

  ipsec_shared_key = var.ipsec_shared_key

  admin_username = var.admin_username

  common_tags = {
    Owner       = var.owner
    Environment = var.environment
    Source      = var.source_change
    Application = var.workload
    Criticality = var.criticality
  }
}