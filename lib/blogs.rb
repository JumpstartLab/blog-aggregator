require 'faraday'
require 'dalli'
require 'memcachier'

module Blogs
  extend self

  def cached_feeds
    authors.map do |author|
      begin
        puts "Reading Blog from cache for #{author.name}"
        author.feed_from_cache
        puts "Feed: #{author.feed.class}"
        author.feed
      rescue Exception => exception
        puts "Problem with #{author.name} cached #{author.feed}:\n\n#{exception}\n\n #{exception.backtrace.join("\n")}"
        nil
      end
    end.compact
  end

  def feeds
    authors.map do |author|
      begin
        puts "Loading Blog for #{author.name}..."
        author.feed_from_url
      rescue Exception => exception
        puts "Problem with #{author.name} URL #{author.url}:\n\n #{exception}"
        nil
      end
    end.compact
  end

  def cache
    authors.each do |author|
      begin
        puts "Caching Blog for #{author.name}..."
        author.feed_from_url
        author.save
      rescue Exception => exception
        puts "Problem with caching #{author.name} URL #{author.url}\n\n #{exception}"
      end
    end
  end

  class Author
    def initialize(name,url)
      @name = name
      @url = url
    end

    attr_reader :name, :url

    attr_accessor :feed

    def feed_from_cache
      self.feed = cache_contents
    end

    def feed_from_url
      self.feed = feed_from_contents url_contents
    end

    def cache_contents
      cache = Dalli::Client.new
      cache.get(cache_key)
    end

    def url_contents
      Faraday.new(url: url).get.body
    end

    def base_url
      url.gsub("/feed.xml","")
    end

    def save
      cache = Dalli::Client.new
      cache.set(cache_key,feed)
    end

    private

    def cache_key
      name.to_s.gsub(' ','-')
    end

    def feed_from_contents(contents)
      feed = Feed.parse(contents, single: true)
      feed.base_url = base_url
      feed.author = name
      feed
    end
  end

  def authors
    self.class.authors
  end

  def self.authors
    @authors ||= []
  end

  def self.author(name,url)
    authors.push Author.new(name,url)
  end

  author "Blair", "http://blairbuilds.herokuapp.com/feed.xml"
  author "Paul", "http://paulblackwell.herokuapp.com/feed.xml"
  author "Phil", "http://phliptos.herokuapp.com/feed.xml"
  author "Erin", "http://ebdrummond.com/feed.xml"
  author "James", "http://xacaxulu-blog.herokuapp.com/feed.xml"
  author "Jennifer", "http://eliuk-gschool-blog.herokuapp.com/feed.xml"
  author "Danny", "http://dannygarcia.herokuapp.com/feed.xml"
  author "Kareem", "http://gthang.herokuapp.com/feed.xml"
  author "Christopher", "http://serknight.herokuapp.com/feed.xml"
  author "Chelsea", "http://komlo.herokuapp.com/feed.xml"
  author "John", "http://jmaddux-blog.herokuapp.com/feed.xml"
  author "Aimee", "http://aimzatron.herokuapp.com/feed.xml"
  author "Josh", "http://jmejia.herokuapp.com/feed.xml"
  author "Daniel", "http://danielmee.herokuapp.com/feed.xml"
  author "Ron", "http://writersblock.herokuapp.com/feed.xml"
  author "Shane", "http://shaneblog.herokuapp.com/feed.xml"
  author "Laura", "http://refactoring-rainbows.herokuapp.com/feed.xml"
  author "Geoff", "http://geoffsblog.herokuapp.com/feed.xml"
  author "Kyle", "http://kylesuss.herokuapp.com/feed.xml"
  author "Logan", "http://logan-gschool.herokuapp.com/feed.xml"
  author "Brad", "http://bradsheehan.herokuapp.com/feed.xml"
  author "Elaine", "http://lalalainexd-blog.herokuapp.com/feed.xml"
  author "Jorge", "http://novohispanoblog.herokuapp.com/feed.xml"
  author "Raphael", "http://raphaelio.herokuapp.com/feed.xml"

end