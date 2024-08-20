param location string
param publicIpName string
param publicIpType string
param publicIpSku string

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: publicIpName
  location: location
  properties: {
    publicIPAllocationMethod: publicIpType
  }
  sku: {
    name: publicIpSku
  }
}

output publicIpId string = publicIp.id
