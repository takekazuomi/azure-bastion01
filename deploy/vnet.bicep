@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the VNET')
param virtualNetworkName string = 'vnet'

var addressPrefix = '10.1.0.0/16'
var subnets = json(loadTextContent('./subnets.json'))

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: subnets
  }
}

output vnetName string = vnet.name
output subnetNames array = [for (s, i) in subnets: s.name]
