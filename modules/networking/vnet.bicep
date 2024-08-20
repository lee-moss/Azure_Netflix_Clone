param virtualNetworkName string
param location string = resourceGroup().location
param vnetAddressPrefix string
param subnet1Name string
param subnet1Prefix string
param subnet2Name string
param subnet2Prefix string


resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
    ]
  }
}

output vnetId string    = vnet.id
output subnet1Id string = vnet.properties.subnets[0].id
output subnet2Id string = vnet.properties.subnets[1].id
