param location string
param nicName string
param subnetId string
param publicIpId string
param nsgId string

resource nic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpId
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

output nicId string = nic.id
