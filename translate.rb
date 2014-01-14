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

unless ARGV[0]
  puts "Usage: ./translate.rb <locale>\n\n"
end

raw = File.read File.join File.dirname(__FILE__), 'app/lib/en.coffee'
compiled = CoffeeScript.compile raw, :bare => true
compiled.sub! /^\n?module\.exports = /, ''
compiled.sub! /\n?;$/, ''
hash = ExecJS.eval compiled
json = JSON.pretty_generate hash

out = File.open File.join(File.dirname(__FILE__), 'public/locales', "#{ ARGV[0] }.json"), 'w'
out.puts json
out.close
