param location string 
param vmConfigs array
param networkSecurityGroupRules array
param virtualNetworkName string
param subnetName string
param networkSecurityGroupName string

@secure()
param adminPassword string

// #############################################################################
// RESOURCE IDS
// #############################################################################

var nsgId     = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
var subnetRef = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)

// #############################################################################
// NETWORK INTERFACE CARDS (NICs)
// #############################################################################

resource nicResources 'Microsoft.Network/networkInterfaces@2023-11-01' = [for vmConfig in vmConfigs: {
  name: '${vmConfig.virtualMachineName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpResources[vmConfig.virtualMachineName].id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    networkSecurityGroupName_resource
    virtualNetworkName_resource
  ]
 }
]

// #############################################################################
// VIRTUAL NETWORK
// #############################################################################

resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

// #############################################################################
// NETWORK SECURITY GROUP
// #############################################################################

resource networkSecurityGroupName_resource 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: networkSecurityGroupRules
  }
}

// #############################################################################
// PUBLIC IP ADDRESSES
// #############################################################################

resource publicIpResources 'Microsoft.Network/publicIPAddresses@2023-11-01' = [for vmConfig in vmConfigs: {
  name: vmConfig.publicIpAddressName
  location: location
  properties: {
    publicIPAllocationMethod: vmConfig.publicIpAddressType
  }
  sku: {
    name: vmConfig.publicIpAddressSku
  }
}]

// #############################################################################
// VIRTUAL MACHINES
// #############################################################################

resource vmResources 'Microsoft.Compute/virtualMachines@2024-03-01' = [for vmConfig in vmConfigs: {
  name: vmConfig.virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    osProfile: {
      computerName: vmConfig.computerName
      adminPassword: adminPassword
      adminUsername: vmConfig.adminLogin
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
          id: nicResources[vmConfig.virtualMachineName].id
        }
      ]
    }
  }
}]
