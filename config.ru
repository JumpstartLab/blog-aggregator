require 'bundler'
Bundler.require

$LOAD_PATH.push File.expand_path('lib')

require 'server'
run Blogs::Server