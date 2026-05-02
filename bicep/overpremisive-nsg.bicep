resource nsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: 'bad-nsg'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'allow-all-inbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
      {
        name: 'allow-ssh'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 110
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}
