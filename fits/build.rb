#!/usr/bin/env ruby

working_directory = File.expand_path Dir.pwd
fits_lib_dir = File.expand_path File.join(File.dirname(__FILE__), '../node_modules/fits')
fits_app_dir = File.expand_path File.dirname(__FILE__)

Dir.chdir fits_lib_dir
`coffee --compile --output lib/ src/`

Dir.chdir fits_app_dir
`../node_modules/hem/bin/hem build`
`coffee -b -c -o ../public workers`
`../node_modules/uglify-js/bin/uglifyjs --overwrite ../public/fits_workers.js`
`mv public/application.js ../public/fits.js`
`rm public/application.css`

Dir.chdir working_directory
