using 'main.bicep'

// Network parameters
param virtualNetworkName         = 'Netflix_Vnet'
param subnetName                 = 'subnet'
param networkSecurityGroupName   = 'myNSG'
param location                   = 'uksouth'

param adminPassword              = az.getSecret('488dbdc5-85c6-402d-811f-eb47d17f391f', 'NetflixProject','NetflixSecret', 'adminPassword')

// VM Configurations
param vmConfigs = [
  {
    computerName: 'JenkinsVM'
    virtualMachineName: 'Jenkins_VM'
    adminLogin: 'JenkinsAdmin'
    publicIpAddressName: 'JenkinsPublicIP'
    publicIpAddressType: 'Static'
    publicIpAddressSku: 'Basic'
  }
  {
    computerName: 'PrometheusVM'
    virtualMachineName: 'Prometheus_VM'
    adminLogin: 'PrometheusAdmin'
    publicIpAddressName: 'PrometheusPublicIP'
    publicIpAddressType: 'Static'
    publicIpAddressSku: 'Basic'
  }
  {
    computerName: 'GrafanaVM'
    virtualMachineName: 'Grafana_VM'
    adminLogin: 'GrafanaAdm'
    publicIpAddressName: 'GrafanaPublicIP'
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
