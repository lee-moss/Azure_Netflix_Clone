using 'main.bicep'

param networkSecurityGroupName = 'myNSG'
param virtualNetworkName       = 'Netflix_Vnet'
param subnetName               = 'subnet'
param location                 = 'UkWest'
param computerName             = ''
param virtualMachineName       = ''

param adminLogin               = ''
param adminPassword            = az.getSecret('your-subscription-id', 'NetflixProject','yourSecret', 'adminLogin')

param networkSecurityGroupRules = [
  {
    name: 'Allow-HTTP'
    properties: {
      priority: 1020
      direction: 'Inbound'
      access: 'Allow'
      protocol: 'Tcp'
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
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
    }
  }
]

param publicIpAddressName = 'YOUR-PUBLIC-IP'

param publicIpAddressType = 'Static'

param publicIpAddressSku = 'Basic'

