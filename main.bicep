param location string 
param virtualNetworkName string
param jenkins_nsg string
param prometheus_nsg string
param jenkinsSubnet string
param monitoringSubnet string
param grafana_nsg string
param jenkins_NsgRules array
param prometheus_NsgRules array
param grafana_NsgRules array

param jenkins_computer    string
param prometheus_computer string
param grafana_computer    string
 

// Admin login for VMs
param adminLogin string
@secure()
param adminPassword string

// Public IP parameters
param jenkinsPublicIpName string 
param prometheusPublicIpName string 
param grafanaPublicIpName string 
param publicIpType string 
param publicIpSku string 

// VM names and NIC names
param jenkinsVmName string 
param prometheusVmName string 
param grafanaVmName string 


// Reference specific subnets
var J_subnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, jenkinsSubnet)
var M_subnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, monitoringSubnet)


// Reference to Jenkins NSG
var jenkinsNsgRef = resourceId('Microsoft.Network/networkSecurityGroups', jenkins_nsg)

// Reference to Prometheus NSG
var prometheusNsgRef = resourceId('Microsoft.Network/networkSecurityGroups', prometheus_nsg)

// Reference to Grafana NSG
var grafanaNsgRef = resourceId('Microsoft.Network/networkSecurityGroups', grafana_nsg)

// #############################################################################
// VIRTUAL NETWORK
// #############################################################################

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'myVnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: jenkinsSubnet
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: monitoringSubnet
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

// #############################################################################
// NETWORK SECURITY GROUP'S
// #############################################################################

resource nsg_jenkins 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: jenkins_nsg
  location: location
  properties: {
    securityRules: jenkins_NsgRules
  }
}

resource nsg_prometheus 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: prometheus_nsg
  location: location
  properties: {
    securityRules: prometheus_NsgRules
  }
}

resource nsg_grafana 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: grafana_nsg
  location: location
  properties: {
    securityRules: grafana_NsgRules
  }
}

// #############################################################################
// NETWORK INTERFACE CARDS
// #############################################################################

resource jenkinsNic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: jenkinsVmName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: J_subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: jenkinsPip.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: jenkinsNsgRef
    }
  }
  dependsOn: [
    nsg_jenkins
    vnet
  ]
}

resource prometheusNic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: prometheusVmName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: M_subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: prometheusPip.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: prometheusNsgRef
    }
  }
  dependsOn: [
    nsg_prometheus
    vnet
  ]
}

resource grafanaNic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: grafanaVmName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: M_subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: grafanaPip.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: grafanaNsgRef
    }
  }
  dependsOn: [
    nsg_grafana
    vnet
  ]
}

// #############################################################################
// PUBLIC IP ADDRESSES
// #############################################################################

resource jenkinsPip 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: jenkinsPublicIpName
  location: location
  properties: {
    publicIPAllocationMethod: publicIpType
  }
  sku: {
    name: publicIpSku
  }
}

resource prometheusPip 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: prometheusPublicIpName
  location: location
  properties: {
    publicIPAllocationMethod: publicIpType
  }
  sku: {
    name: publicIpSku
  }
}

resource grafanaPip 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: grafanaPublicIpName
  location: location
  properties: {
    publicIPAllocationMethod: publicIpType
  }
  sku: {
    name: publicIpSku
  }
}

// #############################################################################
// VIRTUAL MACHINES
// #############################################################################

resource jenkinsVm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: jenkinsVmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    osProfile: {
      computerName: jenkins_computer
      adminPassword: adminPassword
      adminUsername: adminLogin
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: jenkinsNic.id
        }
      ]
    }
  }
}

resource prometheusVm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: prometheusVmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    osProfile: {
      computerName: prometheus_computer
      adminPassword: adminPassword
      adminUsername: adminLogin
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: prometheusNic.id
        }
      ]
    }
  }
}

resource grafanaVm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: grafanaVmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    osProfile: {
      computerName: grafana_computer
      adminPassword: adminPassword
      adminUsername: adminLogin
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: grafanaNic.id
        }
      ]
    }
  }
}
