resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'bad-kv'
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: false
    softDeleteRetentionInDays: 3
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}
