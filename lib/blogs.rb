require 'fileutils'
require 'faraday'

module Blogs
  extend self

  def cached_feeds
    feed_urls.map do |author,url|
      begin
        puts "Reading Blog from cache for #{author}"

        content = File.read("feeds/#{author}.xml")

        feed = Feed.parse(content, single: true)
        feed.base_url = url.gsub("/feed.xml","")
        feed.author = author
        feed
      rescue Exception => exception
        puts "Problem with #{author} cached file:\n\n#{exception}"
        nil
      end
    end.compact
  end

  def feeds
    feed_urls.map do |author,url|
      begin
        puts "Loading Blog for #{author}..."
        content = Faraday.new(url: url).get.body
        feed = Feed.parse(content, single: true)

        feed.base_url = url.gsub("/feed.xml","")
        feed.author = author
        feed
      rescue Exception => exception
        puts "Problem with #{author}- #{url}\n\n: #{exception}"
        nil
      end
    end.compact
  end

  def save
    feeds.each do |feed|
      FileUtils.mkdir_p("feeds")
      File.open "feeds/#{feed.author}.xml", "w" do |file|
        file.write feed.to_xml
      end
    end
  end

  def feed_urls
    @feeds ||= {
      "Blair" => "http://blairbuilds.herokuapp.com/feed.xml",
      "Paul" => "http://paulblackwell.herokuapp.com/feed.xml",
      "Phil" => "http://phliptos.herokuapp.com/feed.xml",
      "Erin" => "http://ebdrummond.com/feed.xml",
      "James" => "http://xacaxulu-blog.herokuapp.com/feed.xml",
      "Jennifer" => "http://eliuk-gschool-blog.herokuapp.com/feed.xml",
      "Danny" => "http://dannygarcia.herokuapp.com/feed.xml",
      "Kareem" => "http://gthang.herokuapp.com/feed.xml",
      "Christopher" => "http://serknight.herokuapp.com/feed.xml",
      "Chelsea" => "http://komlo.herokuapp.com/feed.xml",
      "John" => "http://jmaddux-blog.herokuapp.com/feed.xml",
      "Aimee" => "http://aimzatron.herokuapp.com/feed.xml",
      "Josh" => "http://jmejia.herokuapp.com/feed.xml",
      "Daniel" => "http://danielmee.herokuapp.com/feed.xml",
      "Ron" => "http://writersblock.herokuapp.com/feed.xml",
      "Shane" => "http://shaneblog.herokuapp.com/feed.xml",
      "Laura" => "http://refactoring-rainbows.herokuapp.com/feed.xml",
      "Geoff" => "http://geoffsblog.herokuapp.com/feed.xml",
      "Kyle" => "http://kylesuss.com/feed.xml",
      "Logan" => "http://logan-gschool.herokuapp.com/feed.xml",
      "Brad" => "http://bradsheehan.herokuapp.com/feed.xml",
      "Elaine" => "http://lalalainexd-blog.herokuapp.com/feed.xml",
      "Jorge" => "http://novohispanoblog.herokuapp.com/feed.xml",
      "Raphael" => "http://raphaelio.herokuapp.com/feed.xml" }
  end


end