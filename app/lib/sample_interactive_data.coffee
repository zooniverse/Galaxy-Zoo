Sample =
  
  createRandomId: (length = 24) =>
    characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    result = ""
    i = length
    while i > 0
      result += characters[Math.round(Math.random() * (characters.length - 1))]
      --i
    return result
  
  createRandomCount: => return parseInt(Math.random() * 100)
  
  randomSubject: ->
    
    types = ['smooth_count', 'disk_count', 'other_count']
    key = types[Math.floor(Math.random() * types.length)]
    
    random =
      project_id: 'galaxy-zoo'
      workflow_id: '50217499516bcb0fda000002' # Sloan workflow id
      classification_id: @createRandomId()
      user_id: 1
      user_group_id: 1
      subject:
        smooth_count: 0
        disk_count: 0
        other_count: 0
      group_classification:
        smooth_count: 0
        disk_count: 0
        other_count: 0
    
    random.group_classification[key] = 1
      
    for type in types
      random.subject[type] = @createRandomCount()
    
    return random
    
  randomSample: (number) ->
    sample = []
    for i in [1..number]
      sample.push @randomSubject()
    
    return sample
  
module.exports = Sample