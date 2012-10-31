#!/usr/bin/env ruby

working_directory = File.expand_path Dir.pwd
Dir.chdir File.dirname __FILE__
`../node_modules/hem/bin/hem build`
`mv public/application.js ../public/navigator.js`
`rm public/application.css`
Dir.chdir working_directory
