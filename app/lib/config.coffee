Config =
  test:
    quizzesActive: false
    apiHost: null
    surveys:
      candels:
        id: '50217561516bcb0fda00000d'
        workflowId: '50217499516bcb0fda000003'
      sloan:
        id: '50217561516bcb0fda00000e'
        workflowId: '50217499516bcb0fda000002'
      ukidss:
        id: '5244909c3ae7402d53000001'
        workflowId: '52449f803ae740540e000001'
      ferengi:
        id: '5249cbce3ae740728d000001'
        workflowId: '5249cbc33ae74070ed000001'
      candels_2epoch:
        id: ''
        workflowId: '50217499516bcb0fda000003'
      goods_full:
        id: ''
        workflowId: ''
      sloan_singleband:
        id: ''
        workflowId: ''
    subjectCache: 1
    quiz:
      invitationId: '502bfa73516bcb3c600003e9'
      workflowId: '502a701e516bcb0001000002'
  
  developmentLocal:
    quizzesActive: false
    apiHost: 'http://localhost:3000'
    surveys:
      candels:
        id: '50251c3b516bcb6ecb000001'
        workflowId: '50251c3b516bcb6ecb000001'
      sloan:
        id: '50251c3b516bcb6ecb000002'
        workflowId: '50251c3b516bcb6ecb000002'
      ukidss:
        id: '5244909c3ae7402d53000001'
        workflowId: '52449f803ae740540e000001'
      ferengi:
        id: '5249cbce3ae740728d000001'
        workflowId: '5249cbc33ae74070ed000001'
      candels_2epoch:
        id: ''
        workflowId: '50217499516bcb0fda000003'
      goods_full:
        id: ''
        workflowId: ''
      sloan_singleband:
        id: ''
        workflowId: ''
    subjectCache: 5
    quiz:
      invitationId: '502bfa73516bcb3c600003e9'
      workflowId: '502a701e516bcb0001000002'
  
  developmentRemote:
    quizzesActive: false
    apiHost: 'https://dev.zooniverse.org'
    surveys:
      candels:
        id: '50251c3b516bcb6ecb000001'
        workflowId: '50251c3b516bcb6ecb000001'
      sloan:
        id: '50251c3b516bcb6ecb000002'
        workflowId: '50251c3b516bcb6ecb000002'
      ukidss:
        id: '5244909c3ae7402d53000001'
        workflowId: '52449f803ae740540e000001'
      ferengi:
        id: '5249cbce3ae740728d000001'
        workflowId: '5249cbc33ae74070ed000001'
      candels_2epoch:
        id: '5501b09e7b9f9931d4000001'
        workflowId: '5501b09e7b9f9931d4000002'
      goods_full:
        id: '5501aef27b9f992e7c000001'
        workflowId: '5501aef27b9f992e7c000002'
      sloan_singleband:
        id: '5501a2c17b9f991a95000001'
        workflowId: '5501a9be7b9f992679000001'
    subjectCache: 5
    quiz:
      invitationId: '502bfa73516bcb3c600003e9'
      workflowId: '502a701e516bcb0001000002'

  production:
    quizzesActive: false
    apiHost: 'https://api.zooniverse.org'
    surveys:
      candels:
        id: '50251c3b516bcb6ecb000001'
        workflowId: '50251c3b516bcb6ecb000001'
      sloan:
        id: '50251c3b516bcb6ecb000002'
        workflowId: '50251c3b516bcb6ecb000002'
      ukidss:
        id: '5244909c3ae7402d53000001'
        workflowId: '52449f803ae740540e000001'
      ferengi:
        id: '5249cbce3ae740728d000001'
        workflowId: '5249cbc33ae74070ed000001'
      candels_2epoch:
        id: ''
        workflowId: '50217499516bcb0fda000003'
      goods_full:
        id: ''
        workflowId: ''
      sloan_singleband:
        id: ''
        workflowId: ''
    subjectCache: 5
    quiz:
      invitationId: '502bfa73516bcb3c600003e9'
      workflowId: '502a701e516bcb0001000002'

env = if window.location.port > 1024
  'developmentRemote'
else
  'production'

module.exports = Config[env]
