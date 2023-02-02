# Output Values

output "pip_gateway" {
  description = "PIP of the VNET Gateway"
  value       = azurerm_public_ip.piptestgw.ip_address
}

output "private_ip_vm" {
    description = "Private IP of the VM"
    value = azurerm_linux_virtual_machine.vmcoretest.private_ip_address
}