param networkSecurityGroupName string
param virtualNetworkName string
param subnetName string
param location string 
param computerName string
param networkSecurityGroupRules array
param publicIpAddressName string
param publicIpAddressType string
param publicIpAddressSku string
param virtualMachineName string
param keyVaultName string
param customScriptExtensionName string


param adminLogin string
@secure()
param adminPassword string
@secure()
param sshPublicKey string

var nsgId     = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
var vnetId    = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', virtualNetworkName)
var subnetRef = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', vnetId, subnetName)






// #############################################################################
// KEY VAULT & SSH PUBLIC KEY
// #############################################################################

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

resource sshPublicKeys 'Microsoft.Compute/sshPublicKeys@2024-03-01' = {
  name: '${virtualNetworkName}--sshPublicKeys'
  location: location
  properties: {
    publicKey: reference('${keyVault.id}/secrets/${sshPublicKey}').value
  }
}

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
        publisher: 'bitnami'
        offer:     'jenkins'
        sku:       '1-650'
        version:   'latest'
    }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: computerName
      adminPassword: adminPassword
      adminUsername: adminLogin
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminLogin}/.ssh/authorized_keys'
              keyData: sshPublicKeys.properties.publicKey
            }
          ]
        }        }
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

resource jenkins_docker_script 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = {
  name: customScriptExtensionName 
    location: location
      properties: {
        publisher: 'Microsoft.Compute'
        type: 'CustomScriptExtension'
        typeHandlerVersion: '1.10'
        autoUpgradeMinorVersion: true
        settings: {
          fileUris: [
            'your-path'
      ]
    commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File setup-jenkins-docker.ps1'
    }
  }
}
