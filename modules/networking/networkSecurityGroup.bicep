param location string
param nsgName string
param nsgRules array

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: nsgRules
  }
}

output nsgId string = nsg.id
