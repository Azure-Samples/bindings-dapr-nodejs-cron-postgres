param name string
param location string

@secure()
param postgresUser string
@secure()
param postgresPassword string


param resourceToken string = toLower(uniqueString(subscription().id, name, location))
param tags object = {
  'azd-env-name': name
}

module daprBindingPGResources '../resources/postgres.bicep' = {
  name: name
  params:{
    name: name
    location: location
    resourceToken: resourceToken
    tags: tags
    postgresUser: postgresUser
    postgresPassword: postgresPassword
  }
}
