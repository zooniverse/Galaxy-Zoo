English = require 'lib/en'

class I18n
  @current: English
  
  @iterator: (hash, key) ->
    try
      hash[key]
    catch e
      console?.warn 'missing key: ', key
      ''
  
  @t: (path...) =>
    key = path.join('.').split '.'
    key.reduce(@iterator, @current) or key.reduce(@iterator, English)

$ ->
  lang = require('lib/params').lang
  
  if lang and lang isnt 'en'
    $.getJSON "locales/#{ lang }.json" (json) ->
      I18n.current = json

module.exports = I18n
