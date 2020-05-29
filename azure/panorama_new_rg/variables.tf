variable "virtualMachineRG" {
  description = "Virtual Machine RG"
  default     = "pglynn-test"
}
variable "Location" {
  description = "Location"
  default     = "centralus"
}
variable "virtualNetworkName" {
  description = "Virtual Network Name"
  default     = "panorama"
}
variable "addressPrefix" {
  description = "Address Prefix"
  default     = "10.0.0.0/24"
}
variable "subnetName" {
  description = "Subnet Name"
  default     = "panorama"
}
variable "subnet" {
  description = "Subnet"
  default     = "10.0.0.0/24"
}
variable "publicIpAddressName" {
  description = "Public Ip Address Name"
  default     = "panorama"
}
variable "networkInterfaceName" {
  description = "Network Interface Name"
  default     = "panorama"
}
variable "networkSecurityGroupName" {
  description = "Network Security Group Name"
  default     = "panorama"
}
variable "diagnosticsStorageAccountName" {
  description = "Diagnostics Storage Account Name"
  default     = "panorama"
}
variable "diagnosticsStorageAccountTier" {
  description = "Diagnostics Storage Account Tier"
  default     = "Standard"
}
variable "diagnosticsStorageAccountReplication" {
  description = "Diagnostics Storage Account Replication"
  default     = "LRS"
}
variable "virtualMachineName" {
  description = "Virtual Machine Name"
  default     = "panorama"
}
variable "virtualMachineSize" {
  description = "Virtual Machine Size"
  default     = "Standard_D3"
}
variable "panoramaVersion" {
  description = "Panorama Version"
  default     = "8.1.2"
}
variable "adminUsername" {
  description = "Admin Username"
  default     = "panadmin"
}
variable "adminPassword" {
  description = "Admin Password"
  default     = "Pal0Alt0@123"
}