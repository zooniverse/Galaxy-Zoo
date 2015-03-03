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

env = if window.jasmine
  'test'
else if window.location.port is '9294'
  'developmentRemote'
else if window.location.port > 1024 
  'developmentLocal'
else
  'production'

module.exports = Config[env]
