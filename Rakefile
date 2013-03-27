$LOAD_PATH.push File.expand_path('lib') unless $LOAD_PATH.include? File.expand_path('lib')

require 'blogs'
require 'feed'

task :fetch do
  Blogs.cache
end