#!/usr/bin/env ruby
require 'aws-sdk'

destination = (ARGV[0] ? ARGV[0] : false)
key_path = if destination && destination != 'quick'
  File.join "www.galaxyzoo.org", destination
else
  "www.galaxyzoo.org"
end

AWS.config access_key_id: ENV['AMAZON_ACCESS_KEY_ID'], secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY']
s3 = AWS::S3.new
bucket = s3.buckets['zooniverse-static']

build = <<-BASH
rm -rf build
cp -R public pre_build_public
cp -RL public build_public
rm -rf public
mv build_public public
echo 'Building application...'
hem build
echo 'Building fits...'
./fits/build.rb
echo 'Building navigator...'
./interactive/build.rb
mv public build
mv pre_build_public public
BASH

timestamp = `date -u +%Y-%m-%d_%H-%M-%S`.chomp

compress = <<-BASH
echo 'Compressing...'

timestamp=#{ timestamp }

./node_modules/clean-css/bin/cleancss build/application.css -o "build/application.css"

gzip -9 -c "build/application.js" > "build/application-$timestamp.js"
gzip -9 -c "build/fits.js" > "build/fits-$timestamp.js"
gzip -9 -c "build/navigator.js" > "build/navigator-$timestamp.js"
gzip -9 -c "build/application.css" > "build/application-$timestamp.css"
gzip -9 -c "build/fits_workers.js" > "build/fits_workers.js.gz"
gzip -9 -c "build/javascripts/webfits-canvas.js" > "build/javascripts/webfits-canvas.js.gz"
gzip -9 -c "build/javascripts/webfits-gl.js" > "build/javascripts/webfits-gl.js.gz"

mv build/fits_workers.js.gz build/fits_workers.js
mv build/javascripts/webfits-canvas.js.gz build/javascripts/webfits-canvas.js
mv build/javascripts/webfits-gl.js.gz build/javascripts/webfits-gl.js

rm build/application.js build/fits.js build/navigator.js build/application.css
BASH

system build

index = File.read 'build/index.html'
index.gsub! 'application.js', "application-#{ timestamp }.js"
index.gsub! 'application.css', "application-#{ timestamp }.css"
File.open('build/index.html', 'w'){ |f| f.puts index }

app_js = File.read "build/application.js"
app_js.gsub! 'fits.js', "fits-#{ timestamp }.js"
app_js.gsub! 'navigator.js', "navigator-#{ timestamp }.js"
File.open("build/application.js", 'w'){ |f| f.puts app_js }

system compress
working_directory = File.expand_path Dir.pwd
Dir.chdir 'build'

to_upload = []

if ARGV[0] == 'quick'
  %w(js css html).each{ |ext| to_upload << Dir["**/*.#{ ext }*"] }
  to_upload.flatten!
else
  to_upload = Dir['**/*'].reject{ |path| File.directory? path }
end

to_upload.delete 'index.html'
total = to_upload.length

puts "Uploading to #{ key_path }"

to_upload.each.with_index do |file, index|
  content_type = case File.extname(file)
  when '.html'
    'text/html'
  when '.js'
    'application/javascript'
  when '.css'
    'text/css'
  when '.gz'
    'application/x-gzip'
  when '.ico'
    'image/x-ico'
  else
    `file --mime-type -b #{ file }`.chomp
  end

  puts "#{ '%2d' % (index + 1) } / #{ '%2d' % total }: Uploading #{ file } as #{ content_type }"
  options = { file: file, acl: :public_read, content_type: content_type }

  if content_type == 'application/javascript' || content_type == 'text/css'
    options[:content_encoding] = 'gzip'
  end

  bucket.objects["#{ key_path }/#{ file }"].write options
end

bucket.objects["#{ key_path }/index.html"].write file: 'index.html', acl: :public_read, content_type: 'text/html', cache_control: 'no-cache, must-revalidate'

Dir.chdir working_directory
`rm -rf build`
puts 'Done!'
