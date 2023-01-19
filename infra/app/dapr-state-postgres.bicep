param name string
param location string

param postgresUser string = 'testdeveloper'

@secure()
param postgresPassword string

var resourceToken = toLower(uniqueString(subscription().id, name, location))
param tags object = {
  'azd-env-name': name
}

module daprBindingPGResources '../core/flexibleserver.bicep' = {
  name: 'dapr-binding-pg-${resourceToken}'
  params:{
    name: 'pg${resourceToken}'
    location: location
    tags: tags
    sku: {
      name: 'Standard_B2s'
      tier: 'Burstable'
    }
    storage: {
      storageSizeGB: 64
    }
    version: '11'
    administratorLogin: postgresUser
    administratorLoginPassword: postgresPassword
    enableFirewall: true
  }
}
