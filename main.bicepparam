using 'main.bicep'

// Network and VM parameters
param networkSecurityGroupName = 'myNSG' // Name of the Network Security Group
param virtualNetworkName       = 'Netflix_Vnet' // Name of the Virtual Network
param subnetName               = 'subnet' // Name of the Subnet
param location                 = 'UkWest' // Deployment location
param computerName             = '' // Name of the computer
param virtualMachineName       = '' // Name of the Virtual Machine

// Admin credentials and Key Vault
param adminLogin               = '' // Admin login username
param keyVaultName             = 'Your-keyvault' // Name of the Key Vault
param adminPassword            = az.getSecret('your-subscription-id', 'NetflixProject','yourSecret', 'adminLogin') // Admin password from Key Vault
param sshPublicKey             = az.getSecret('your-subscription-id', 'NetflixProject','yourSecret', 'sshPublicKey') // SSH public key from Key Vault

// Custom script extension
param customScriptExtensionName  = 'installJenkins' // Name of the custom script extension

// Network Security Group rules
param networkSecurityGroupRules = [
  {
    name: 'Allow-HTTP'
    properties: {
      priority: 1020
      direction: 'Inbound'
      access: 'Allow'
      protocol: 'TCP'
      sourcePortRange: '*'
      destinationPortRange: '80'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
    }
  }
  {
    name: 'Allow-HTTPS'
    properties: {
      priority: 1030
      direction: 'Inbound'
      access: 'Allow'
      protocol: 'TCP'
      sourcePortRange: '*'
      destinationPortRange: '443'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
    }
  }
  {
    name: 'SSH'
    properties: {
      priority: 1031
      protocol: 'TCP'
      access: 'Allow'
      direction: 'Inbound'
      sourceApplicationSecurityGroups: []
      destinationApplicationSecurityGroups: []
      sourceAddressPrefix: '*'
      sourcePortRange: '*'
      destinationAddressPrefix: '*'
      destinationPortRange: '22'
    }
  }
]

// Public IP address parameters
param publicIpAddressName = 'YOUR-PUBLIC-IP' // Name of the Public IP address
param publicIpAddressType = 'Static' // Type of the Public IP address
param publicIpAddressSku = 'Basic' // SKU of the Public IP address
