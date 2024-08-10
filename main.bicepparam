using 'main.bicep'

// Network parameters
param virtualNetworkName         = 'Netflix_Vnet'
param jenkins_nsg                = 'nsg1'
param prometheus_nsg             = 'nsg2'
param grafana_nsg                = 'nsg3'
param jenkinsSubnet              = 'subnet1'
param monitoringSubnet           = 'subnet2'
param jenkins_computer           = 'jkc'
param prometheus_computer        = 'prc'
param grafana_computer           = 'grc'


param location                   = 'uksouth'

param adminLogin                 = 'LAM5'
param adminPassword              = az.getSecret('488dbdc5-85c6-402d-811f-eb47d17f391f', 'NetflixProject','NetflixSecret', 'adminPassword')

// Public IP parameters
param jenkinsPublicIpName        = 'jenkinsPublicIp'
param prometheusPublicIpName     = 'prometheusPublicIp'
param grafanaPublicIpName        = 'grafanaPublicIp'
param publicIpType               = 'Static'
param publicIpSku                = 'Basic'

// VM names and NIC names
param jenkinsVmName              = 'jenkinsVm'
param prometheusVmName           = 'prometheusVm'
param grafanaVmName              = 'grafanaVm'

// Network security group rules
param jenkins_NsgRules = [
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
    name: 'Open_for_Jenkins'
    properties: {
      priority: 101
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

param prometheus_NsgRules = [
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
]

param grafana_NsgRules = [
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
]
