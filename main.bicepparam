using 'main.bicep'

param networkSecurityGroupName = 'myNSG'
param virtualNetworkName       = 'Netflix_Vnet'
param subnetName               = 'subnet'
param location                 = 'UkWest'
param computerName             = ''
param virtualMachineName       = ''

param adminLogin               = ''
param keyVaultName             = 'Your-keyvault'
param adminPassword            = az.getSecret('your-subscription-id', 'NetflixProject','yourSecret', 'adminLogin')
param sshPublicKey             = az.getSecret('your-subscription-id', 'NetflixProject','yourSecret', 'sshPublicKey')

param customScriptExtensionName  = 'installJenkins'

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

param publicIpAddressName = 'YOUR-PUBLIC-IP'

param publicIpAddressType = 'Static'

param publicIpAddressSku = 'Basic'

