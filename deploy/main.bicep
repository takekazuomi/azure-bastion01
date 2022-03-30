@description('The name of you Virtual Machine.')
param vmName string = 'flatcar'

@description('Username for the Virtual Machine.')
param adminUsername string = 'core'

@description('SSH Key for the Virtual Machine.')
@secure()
param adminSshKey string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('flatcar-${uniqueString(resourceGroup().id)}')

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The size of the VM')
param vmSize string = 'Standard_B1s'

@description('Name of the VNET')
param virtualNetworkName string = 'vnet'

@description('Name of the Network Security Group')
param networkSecurityGroupName string = 'nsg'

@description('Name of the prefix')
param namePrefix string = replace(resourceGroup().name, '-rg','')

module la 'logging.bicep' = {
  name: 'la'
  params:{
    location:location
    namePrefix: namePrefix
  }
}

module vnet 'vnet.bicep' = {
  name: 'vnet'
  params:{
    location:location
  }
}

module nsg 'nsg.bicep' = {
  name: 'nsg'
  params: {
    location: location
    name: networkSecurityGroupName
    laName:la.outputs.laName
  }
}

module vm 'vm.bicep' = {
  name: 'vm'
  params: {
    vmName: vmName
    adminUsername: adminUsername
    adminSshKey: adminSshKey
    dnsLabelPrefix: dnsLabelPrefix
    location: location
    vmSize: vmSize
    virtualNetworkName: virtualNetworkName
    subnetName: vnet.outputs.subnetNames[0]
    networkSecurityGroupName: nsg.outputs.nsgName
    laName:la.outputs.laName
  }
}

module bastion 'bastion.bicep' = {
  name: 'bastion'
  params: {
    bastionHostName: 'bastion'
    bastionHostSku: 'Standard'
    location: location
    publicIpAddressName: 'bastion-pip'
    vnetName:vnet.outputs.vnetName
    laName:la.outputs.laName
  }
}

output adminUsername string = vm.outputs.adminUsername
output hostname string = vm.outputs.hostName
output sshCommand string = vm.outputs.sshCommand
output workspaceName string = la.outputs.laName
