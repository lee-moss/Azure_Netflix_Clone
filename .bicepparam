using 'main.bicep'

param networkSecurityGroupName = 'myNSG'
param virtualNetworkName       = 'Netflix_Vnet'
param subnetName               = 'subnet'
param location                 = 'UkWest'
param computerName             = ''

param adminLogin               = ''
param adminPassword            = az.getSecret('your-subscription-id', 'NetflixProject','yourSecret', 'adminLogin')
