require 'sinatra/base'
require 'blogs'
require 'feed'

module Blogs
  class Server < Sinatra::Base

    get '/' do
      @entries = Blogs.cached_feeds.map {|feed| feed.entries.map {|entry| entry } }.flatten.sort_by {|entry| entry.published }.reverse
      erb :index
    end

  end
end