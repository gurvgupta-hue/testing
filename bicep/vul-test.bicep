// vulnerable-test.bicep

@description('Location for all resources.')
param location string = resourceGroup().location

// =========================================================
// ❌ VULNERABLE STORAGE ACCOUNT
// =========================================================
resource badStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'insecurestorage12345'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    // PSRule Failure: Allows HTTP traffic (Secure Transfer disabled)
    supportsHttpsTrafficOnly: false 
    
    // PSRule Failure: Allows anonymous public read access to containers
    allowBlobPublicAccess: true 
    
    // PSRule Failure: Uses deprecated TLS 1.0 instead of 1.2
    minimumTlsVersion: 'TLS1_0' 
    
    // PSRule Failure: Network rules allow access from all networks
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow' 
    }
  }
}

// =========================================================
// ❌ VULNERABLE NETWORK SECURITY GROUP (NSG)
// =========================================================
resource badNsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: 'open-to-the-world-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-RDP-Internet'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          // PSRule Failure: RDP Port 3389 open to the entire internet
          sourceAddressPrefix: '*' 
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'Allow-SSH-Internet'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          // PSRule Failure: SSH Port 22 open to the entire internet
          sourceAddressPrefix: 'Internet' 
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}
