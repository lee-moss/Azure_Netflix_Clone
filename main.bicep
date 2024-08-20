param jenkins_NsgRules array
param prometheus_NsgRules array
param grafana_NsgRules array
param location string 

param adminLogin string
@secure()
param adminPassword string

// #############################################################################
// VIRTUAL NETWORK
// #############################################################################

<<<<<<< HEAD
module vnetModule 'modules/networking/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    virtualNetworkName: 'myVNet'
    vnetAddressPrefix: '10.0.0.0/16'
    subnet1Name: 'jenkinsSubnet'
    subnet1Prefix: '10.0.1.0/24'
    subnet2Name: 'monitoringSubnet'
    subnet2Prefix: '10.0.2.0/24'
=======
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
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
>>>>>>> e5502cc5ceca0a545edb39e68df566064f096283
  }
}

output vnetId string = vnetModule.outputs.vnetId
output jenkinsSubnetId string = vnetModule.outputs.subnet1Id
output monitoringSubnetId string = vnetModule.outputs.subnet2Id

// #############################################################################
// NETWORK SECURITY GROUP'S
// #############################################################################

module jenkinsNsg 'modules/networking/networkSecurityGroup.bicep' = {
  name: 'jenkinsNsgDeployment'
  params: {
    location: location
    nsgName: 'jenkinsNsg'
    nsgRules: [
      jenkins_NsgRules
    ]
  }
}

module prometheusNsg 'modules/networking/networkSecurityGroup.bicep' = {
  name: 'prometheusNsgDeployment'
  params: {
    location: location
    nsgName: 'prometheusNsg'
    nsgRules: [
      prometheus_NsgRules
    ]
  }
}

module grafanaNsg 'modules/networking/networkSecurityGroup.bicep' = {
  name: 'grafanaNsgDeployment'
  params: {
    location: location
    nsgName: 'grafanaNsg'
    nsgRules: [
      grafana_NsgRules
    ]
  }
}

// #############################################################################
// NETWORK INTERFACE CARDS
// #############################################################################

module jenkinsNic 'modules/networking/networkInterfaceCard.bicep' = {
  name: 'jenkinsNicDeployment'
  params: {
    location: location
    nicName: 'jenkinsNic'
    subnetId: vnetModule.outputs.subnet1Id
    publicIpId: jenkinsPip.outputs.publicIpId
    nsgId: jenkinsNsg.outputs.nsgId
  }
}

module prometheusNic 'modules/networking/networkInterfaceCard.bicep' = {
  name: 'prometheusNicDeployment'
  params: {
    location: location
    nicName: 'prometheusNic'
    subnetId: vnetModule.outputs.subnet2Id
    publicIpId: prometheusPip.outputs.publicIpId
    nsgId: prometheusNsg.outputs.nsgId
  }
}

module grafanaNic 'modules/networking/networkInterfaceCard.bicep' = {
  name: 'grafanaNicDeployment'
  params: {
    location: location
    nicName: 'grafanaNic'
    subnetId: vnetModule.outputs.subnet2Id
    publicIpId: grafanaPip.outputs.publicIpId
    nsgId: grafanaNsg.outputs.nsgId
  }
}

// #############################################################################
// PUBLIC IP ADDRESSES
// #############################################################################

module jenkinsPip 'modules/networking/publicIpAddress.bicep' = {
  name: 'jenkinsPipDeployment'
  params: {
    location: location
    publicIpName: 'jenkinsPublicIp'
    publicIpType: 'Dynamic'
    publicIpSku: 'Basic'
  }
}

module prometheusPip 'modules/networking/publicIpAddress.bicep' = {
  name: 'prometheusPipDeployment'
  params: {
    location: location
    publicIpName: 'prometheusPublicIp'
    publicIpType: 'Dynamic'
    publicIpSku: 'Basic'
  }
}

module grafanaPip 'modules/networking/publicIpAddress.bicep' = {
  name: 'grafanaPipDeployment'
  params: {
    location: location
    publicIpName: 'grafanaPublicIp'
    publicIpType: 'Dynamic'
    publicIpSku: 'Basic'
  }
}

// #############################################################################
// VIRTUAL MACHINES
// #############################################################################

module jenkinsVm 'modules/compute/virtualMachine.bicep' = {
  name: 'jenkinsVmDeployment'
  params: {
    location: location
    vmName: 'jenkinsVm'
    vmSize: 'Standard_D2s_v3'
    adminLogin: adminLogin
    adminPassword: adminPassword
    computerName: 'jenkins-computer'
    nicId: jenkinsNic.outputs.nicId
  }
}

module prometheusVm 'modules/compute/virtualMachine.bicep' = {
  name: 'prometheusVmDeployment'
  params: {
    location: location
    vmName: 'prometheusVm'
    vmSize: 'Standard_D2s_v3'
    adminLogin: adminLogin
    adminPassword: adminPassword
    computerName: 'prometheus-computer'
    nicId: prometheusNic.outputs.nicId
  }
}

module grafanaVm 'modules/compute/virtualMachine.bicep' = {
  name: 'grafanaVmDeployment'
  params: {
    location: location
    vmName: 'grafanaVm'
    vmSize: 'Standard_D2s_v3'
    adminLogin: adminLogin
    adminPassword: adminPassword
    computerName: 'grafana-computer'
    nicId: grafanaNic.outputs.nicId
  }
}
