Config =
  test:
    apiHost: null
    surveys:
      candels: '50217561516bcb0fda00000d'
      sloan: '50217561516bcb0fda00000e'
    subjectCache: 1
  
  development:
    apiHost: 'http://localhost:3000'
    surveys:
      candels: '50241171516bcb61680003eb'
      sloan: '50241171516bcb61680003ec'
    subjectCache: 5
  
  production:
    apiHost: 'https://api.zooniverse.org'
    surveys:
      candels: '50217561516bcb0fda00000d'
      sloan: '50217561516bcb0fda00000e'
    subjectCache: 5

env = if window.jasmine
  'test'
else if window.location.port > 1024
  'development'
else
  'production'

module.exports = Config[env]
