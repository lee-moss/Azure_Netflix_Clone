param networkSecurityGroupName string 
param virtualNetworkName string
param subnetName string
param location string 
param adminLogin string
param computerName string

@secure()
param adminPassword string

resource Vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
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

resource NSG 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP'
        properties: {
          priority: 1000
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
          priority: 1001
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
  }
}

resource NIC 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'Netflix_VM-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'Netflix_Vnet', 'subnet')
          }
          }
            // privateIPAllocationMethod: 'Dynamic'
         }
     ]
  }
}

    
// #############################################################################
// VIRTUAL MACHINE
// #############################################################################

resource Virtual_Machine 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'Netflix_VM'
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
