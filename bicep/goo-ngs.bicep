resource nsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: 'good-nsg'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'allow-app-tier'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: '10.0.0.0/24'
          destinationPortRange: '443'
        }
      }
    ]
  }
}
