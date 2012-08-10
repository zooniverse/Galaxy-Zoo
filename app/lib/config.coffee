Config =
  test:
    apiHost: null
    surveys:
      candels:
        id: '50217561516bcb0fda00000d'
        workflowId: '50217499516bcb0fda000003'
      sloan:
        id: '50217561516bcb0fda00000e'
        workflowId: '50217499516bcb0fda000002'
    subjectCache: 1
  
  development:
    apiHost: 'http://localhost:3000'
    surveys:
      candels:
        id: '50217561516bcb0fda00000d'
        workflowId: '50217499516bcb0fda000003'
      sloan:
        id: '50217561516bcb0fda00000e'
        workflowId: '50217499516bcb0fda000002'
    subjectCache: 5
  
  production:
    apiHost: 'https://api.zooniverse.org'
    surveys:
      candels:
        id: '50217561516bcb0fda00000d'
        workflowId: '50217499516bcb0fda000003'
      sloan:
        id: '50217561516bcb0fda00000e'
        workflowId: '50217499516bcb0fda000002'
    subjectCache: 5

env = if window.jasmine
  'test'
else if window.location.port > 1024
  'development'
else
  'production'

module.exports = Config[env]
