Config =
  test:
    apiHost: null
    subjectCache: 1
  
  developmentLocal:
    apiHost: 'http://localhost:3000'
    subjectCache: 5
  
  developmentRemote:
    apiHost: 'https://dev.zooniverse.org'
    subjectCache: 5
  

  production:
    apiHost: 'https://api.zooniverse.org'
    subjectCache: 5

env = if window.jasmine
  'test'
else if window.location.port is '9294'
  'developmentRemote'
else if window.location.port > 1024 
  'developmentLocal'
else
  'production'

module.exports = Config[env]
