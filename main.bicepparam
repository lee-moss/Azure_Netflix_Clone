using 'main.bicep'

// Network parameters
param networkSecurityGroupName   = 'myNSG'
param virtualNetworkName         = 'Netflix_Vnet'
param subnetName                 = 'subnet'
param location                   = 'uksouth'

// VM parameters
param computerName               = 'NetflixComp'
param virtualMachineName         = 'Netflix_VM'

// Admin credentials
param adminLogin                 = 'LAM5'
param authenticationType         = 'sshPublicKey'
param adminPasswordOrKey         = az.getSecret('488dbdc5-85c6-402d-811f-eb47d17f391f', 'NetflixProject','NetflixSecret', 'adminPassword')


// Network security group rules
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
      priority: 1040
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

// Public IP parameters
param publicIpAddressName = 'PUBLIC-IP-NETFLIX'
param publicIpAddressType = 'Static'
param publicIpAddressSku = 'Basic'
