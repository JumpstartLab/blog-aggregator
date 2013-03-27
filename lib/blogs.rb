require 'fileutils'
require 'faraday'

module Blogs
  extend self

  def cached_feeds
    authors.map do |author|
      begin
        puts "Reading Blog from cache for #{author.name}"
        author.feed_from_file
      rescue Exception => exception
        puts "Problem with #{author.name} cached file #{author.file}:\n\n#{exception}"
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
      puts "Caching Blog for #{author.name}..."
      author.save
    end
  end

  class Author
    attr_reader :name, :url, :file
    def initialize(name,url,file)
      @name = name
      @url = url
      @file = file
    end

    def feed_from_file
      feed_from_contents file_contents
    end

    def feed_from_url
      feed_from_contents url_contents
    end

    def file_contents
      File.read file
    end

    def url_contents
      Faraday.new(url: url).get.body
    end

    def base_url
      url.gsub("/feed.xml","")
    end

    def save
      FileUtils.mkdir_p("feeds")
      File.open file, "w" do |file|
        file.write url_contents
      end
    end

    private

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
    authors.push Author.new(name,url,"feeds/#{name}.xml")
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
  author "Kyle", "http://kylesuss.com/feed.xml"
  author "Logan", "http://logan-gschool.herokuapp.com/feed.xml"
  author "Brad", "http://bradsheehan.herokuapp.com/feed.xml"
  author "Elaine", "http://lalalainexd-blog.herokuapp.com/feed.xml"
  author "Jorge", "http://novohispanoblog.herokuapp.com/feed.xml"
  author "Raphael", "http://raphaelio.herokuapp.com/feed.xml"

end