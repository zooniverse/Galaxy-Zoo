query = document.location.search.replace('?', '').split '&'
params = { }

for string in query
  [key, value] = string.split '='
  params[key] = value if key

module.exports = params
