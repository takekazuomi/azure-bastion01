@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the VNET')
param virtualNetworkName string = 'vnet'

var addressPrefix = '10.1.0.0/16'
var subnets = json(loadTextContent('./subnets.json'))

module vnet 'br/public:network/virtual-network:1.0.1' = {
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    name: virtualNetworkName
    location:location
    addressPrefixes:[
      addressPrefix
    ]
    subnets: subnets
  }
}

output vnetName string = vnet.outputs.name
output subnetNames array = [for (s, i) in subnets: s.name]
