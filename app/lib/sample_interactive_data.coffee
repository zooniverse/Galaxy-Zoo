Sample =
  
  createRandomId: (length = 24) =>
    characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    result = ""
    i = length
    while i > 0
      result += chars[Math.round(Math.random() * (chars.length - 1))]
      --i
    return result
  
  createRandomCount: => return parseInt(Math.random() * 100)
  
  randomSubject: =>
    random =
      project_id: 'galaxy-zoo'
      workflow_id: '50217499516bcb0fda000002' # Sloan
      classification_id: @randomId()
      user_id: 1
      user_group_id: 1
      subject:
        smooth_count: @createRandomCount()
        disk_count: 0
        other_count: 0
      group_classification:
        smooth_count: @createRandomCount()
        disk_count: 0
        other_count: 0

module.exports = Sample