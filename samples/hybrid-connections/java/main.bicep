// + Create Azure Relay namespace
// + Create Azure Relay hybrid connection
// + Create access policy for the hybrid connection and get access keys
// + Create Event Grid subscription to azure relay hybrid connection


param location string = 'northeurope'
param relay_name string = 'kpnewrelay'
param hybrid_connection_name string = 'test_connection'
param hybrid_connection_policy_name string = 'admin'

resource relay 'Microsoft.Relay/namespaces@2018-01-01-preview' = {
  name : relay_name
  location: location
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