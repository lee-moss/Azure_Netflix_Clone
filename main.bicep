param networkSecurityGroupName string
param virtualNetworkName string
param subnetName string
param location string 
param adminLogin string
param computerName string
param networkSecurityGroupRules array
param publicIpAddressName string
param publicIpAddressType string
param publicIpAddressSku string
param virtualMachineName string


@secure()
param adminPassword string

var nsgId     = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
var vnetId    = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', virtualNetworkName)
var subnetRef = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', vnetId, subnetName)



// #############################################################################
// NETWORK INTERFACE CARD
// #############################################################################

resource NIC 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'Netflix_VM-nic'
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
            id: PiP.id
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
// #############################################################################
// VIRTUAL NETWORK
// #############################################################################

resource virtualNetworkName_resource'Microsoft.Network/virtualNetworks@2023-11-01' = {
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
// PUBLIC IP
// #############################################################################

resource PiP 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
   name : publicIpAddressName
   location: location
  properties: {
    publicIPAllocationMethod: publicIpAddressType
  }
  sku: {
    name: publicIpAddressSku
  }
}
    
// #############################################################################
// VIRTUAL MACHINE
// #############################################################################

resource Virtual_Machine 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
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
      osProfile: {
        computerName: computerName
        adminPassword: adminPassword
        adminUsername: adminLogin
    }
      networkProfile: {
        networkInterfaces: [
          {
            id: resourceId('Microsoft.Network/networkInterfaces', 'Netflix_VM-nic')
          }
        ]
      }
    }
  }
