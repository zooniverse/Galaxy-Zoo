#!/usr/bin/env ruby

# Requires the coffeescript gem
# Install with
#   gem install coffee-script

gem 'coffee-script'
require 'coffee_script'

require 'json/common'
module JSON
  require 'json/version'

  begin
    require 'json/ext'
  rescue
    require 'json/pure'
  end
end

raw = File.read '/Users/Rob/Downloads/italiano.coffee'
compiled = CoffeeScript.compile raw, :bare => true
compiled.sub! /^\n?module\.exports = /, ''
compiled.sub! /\n?;$/, ''
hash = ExecJS.eval compiled
json = JSON.pretty_generate hash

out = File.open '/Users/Rob/Downloads/it.json', 'w'
out.puts json
