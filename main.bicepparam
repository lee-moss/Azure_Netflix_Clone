using 'main.bicep'

// Network parameters
param virtualNetworkName         = ''
param subnetName                 = 'subnet'
param networkSecurityGroupName   = 'myNSG'
param location                   = 'uksouth'

param adminPassword              = az.getSecret('')

// VM Configurations
param vmConfigs = [
  {
    computerName: 'Jenkins'
    virtualMachineName: ''
    adminLogin: ''
    publicIpAddressName: ''
    publicIpAddressType: 'Static'
    publicIpAddressSku: 'Basic'
  }
  {
    computerName: 'Prometheus'
    virtualMachineName: '
    adminLogin: ''
    publicIpAddressName: ''
    publicIpAddressType: 'Static'
    publicIpAddressSku: 'Basic'
  }
  {
    computerName: 'Grafana'
    virtualMachineName: ''
    adminLogin: ''
    publicIpAddressName: ''
    publicIpAddressType: 'Static'
    publicIpAddressSku: 'Basic'
  }
]

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
      priority: 100
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
  {
    name: 'Open 8080'
    properties: {
      priority: 100
      protocol: 'TCP'
      access: 'Allow'
      direction: 'Inbound'
      sourceApplicationSecurityGroups: []
      destinationApplicationSecurityGroups: []
      sourceAddressPrefix: '*'
      sourcePortRange: '*'
      destinationAddressPrefix: '*'
      destinationPortRange: '8080'
    }
  }
]
