#!/usr/bin/env ruby

working_directory = File.expand_path Dir.pwd
Dir.chdir File.dirname __FILE__
`../node_modules/hem/bin/hem build`
`coffee -b -c -o ../public workers`
`../node_modules/uglify-js/bin/uglifyjs --overwrite ../public/fits_workers.js`
`mv public/application.js ../public/fits.js`
`rm public/application.css`
Dir.chdir working_directory
