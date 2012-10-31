#!/usr/bin/env ruby

Dir.chdir File.dirname __FILE__
`../node_modules/hem/bin/hem build`
`mv public/application.js ../public/navigator.js`
`rm public/application.css`
