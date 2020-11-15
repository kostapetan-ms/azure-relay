param location string = 'northeurope'
param storage_account_name string = 'kpnewstorage'
param relay_name string = 'kpnewrelay'
param hybrid_connection_name string = 'test_connection'
param hybrid_connection_policy_name string = 'admin'
param event_grid_subscription_name string = 'imagessubscription'
param event_grid_name string = 'egimagessub'

resource storage_account 'Microsoft.Storage/storageAccounts@2020-08-01-preview' = {
  kind :'StorageV2'
  location : location
  name: storage_account_name
  sku : {
    tier : 'Standard'
    name : 'Standard_ZRS'
  }
  properties : {
    accessTier : 'Hot'
  }
}

resource relay 'Microsoft.Relay/namespaces@2018-01-01-preview' = {
  name : relay_name
  location: location
  properties:{

  }
}

resource event_grid 'Microsoft.EventGrid/systemTopics@2020-04-01-preview' = {
  name: event_grid_name
  location: location
  properties: {
      source: storage_account.id
      topicType: 'Microsoft.Storage.StorageAccounts'
  }
}



resource hybrid_connection 'Microsoft.Relay/namespaces/hybridConnections@2017-04-01' = {
  name : '${relay.name}/${hybrid_connection_name}'
  properties : {
    requiresClientAuthorization: true
  }
}

resource hybrid_connection_policy 'Microsoft.Relay/namespaces/hybridConnections/authorizationRules@2017-04-01' = {
  name : '${hybrid_connection.name}/${hybrid_connection_policy_name}'
  properties :{
    rights : [ 
      'Listen'
      'Send'
     ]
  }
}

resource event_grid_subscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2020-04-01-preview' = {
  name : '${event_grid.name}/${event_grid_subscription_name}'
  properties: {
    eventDeliverySchema :'CloudEventSchemaV1_0'
    destination : {
      endpointType:'HybridConnection'
      properties:{
        resourceId:hybrid_connection.id
      }
    }
  }
}