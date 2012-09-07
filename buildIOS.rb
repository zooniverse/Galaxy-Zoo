#!/usr/bin/env ruby

# require 'aws-sdk'
# AWS.config access_key_id: ENV['S3_ACCESS_ID'], secret_access_key: ENV['S3_SECRET_KEY']
# s3 = AWS::S3.new
# bucket = s3.buckets['www.galaxyzoo.org']

build = <<-BASH

hem build
cp -r public/* GalaxyZooIOS/www/
BASH

# timestamp = `date -u +%Y-%m-%d_%H-%M-%S`.chomp

# compress = <<-BASH
# echo 'Compressing...'

# timestamp=#{ timestamp }

# mv build/application.js "build/application-$timestamp.js"
# ./node_modules/clean-css/bin/cleancss build/application.css -o "build/application-$timestamp.css"
# rm build/application.css
# gzip -9 -c "build/application-$timestamp.js" > "build/application-$timestamp.js.gz"
# gzip -9 -c "build/application-$timestamp.css" > "build/application-$timestamp.css.gz"
# BASH

system build
# system compress

# index = File.read 'build/index.html'
# index.gsub! 'application.js', "application-#{ timestamp }.js"
# index.gsub! 'application.css', "application-#{ timestamp }.css"
# File.open('build/index.html', 'w'){ |f| f.puts index }

# working_directory = Dir.pwd
# Dir.chdir 'build'
# to_upload = Dir['**/*'].reject{ |path| File.directory? path }
# to_upload.delete 'index.html'
# to_upload << 'index.html'
# total = to_upload.length

# to_upload.each.with_index do |file, index|
#   content_type = case File.extname(file)
#   when '.html'
#     'text/html'
#   when '.js'
#     'application/javascript'
#   when '.css'
#     'text/css'
#   when '.gz'
#     'application/x-gzip'
#   when '.ico'
#     'image/x-ico'
#   else
#     `file --mime-type -b #{ file }`.chomp
#   end
  
#   puts "#{ '%2d' % (index + 1) } / #{ '%2d' % total }: Uploading #{ file } as #{ content_type }"
#   bucket.objects[file].write file: file, acl: :public_read, content_type: content_type
# end

# Dir.chdir working_directory
# `rm -rf build`
# puts 'Done!'
