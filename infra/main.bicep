targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unqiue hash used in all resources.')
param name string

@secure()
param postgresUser string
@secure()
param postgresPassword string

@minLength(1)
@description('Primary location for all resources')
param location string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${name}-rg'
  location: location
}

module application 'building-blocks/paas-application.bicep' = {
  name: 'bindings-dapr-aca-paas'
  params: {
    name: name
    location: location
    postgresUser: postgresUser
    postgresPassword: postgresPassword
  }
  scope: resourceGroup
  dependsOn:[
    state
  ]
}

module batchContainerApp 'resources/batch.bicep' = {
  name: 'ca-batch'
  params:{
    name: name
    location: location
  }
  scope: resourceGroup
  dependsOn:[
    application
  ]
}

module state 'building-blocks/dapr-state-postgres.bicep' = {
  name: 'bindings-pg-orders'
  params: {
    name: name
    location: location
    postgresUser: postgresUser
    postgresPassword: postgresPassword
  }
  scope: resourceGroup
}

output AZURE_KEY_VAULT_ENDPOINT string = application.outputs.KEY_VAULT_ENDPOINT
output APPINSIGHTS_INSTRUMENTATIONKEY string = application.outputs.APPINSIGHTS_INSTRUMENTATIONKEY
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = application.outputs.CONTAINER_REGISTRY_ENDPOINT
output AZURE_CONTAINER_REGISTRY_NAME string = application.outputs.CONTAINER_REGISTRY_NAME
output APP_CHECKOUT_BASE_URL string = batchContainerApp.outputs.CONTAINERAPP_URI
output APP_APPINSIGHTS_INSTRUMENTATIONKEY string = application.outputs.APPINSIGHTS_INSTRUMENTATIONKEY
