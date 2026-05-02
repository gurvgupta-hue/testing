param location string = resourceGroup().location

// ❌ VULNERABLE STORAGE
resource badStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'insecurestorage12345'
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: false
    allowBlobPublicAccess: true
    minimumTlsVersion: 'TLS1_0'
  }
}

// ❌ VULNERABLE KEY VAULT
resource badVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'insecure-vault-123'
  location: location
  properties: {
    sku: { family: 'A', name: 'standard' }
    tenantId: subscription().tenantId
    enableSoftDelete: false // PSRule Failure: Soft delete must be enabled
    enablePurgeProtection: false // PSRule Failure: Purge protection must be enabled
    accessPolicies: []
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Allow' // PSRule Failure: Firewall is open to the internet
    }
  }
}

// ❌ VULNERABLE SQL SERVER
resource badSqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'insecure-sql-server-123'
  location: location
  properties: {
    administratorLogin: 'adminUser'
    administratorLoginPassword: 'Password123!' 
    publicNetworkAccess: 'Enabled' // PSRule Failure: Public network access allowed
  }
}

// ❌ VULNERABLE SQL FIREWALL RULE
resource badSqlFirewall 'Microsoft.Sql/servers/firewallRules@2021-11-01' = {
  parent: badSqlServer
  name: 'AllowAllAzureIPs'
  properties: {
    startIpAddress: '0.0.0.0' // PSRule Failure: Allows all Azure-internal traffic
    endIpAddress: '0.0.0.0'
  }
}
