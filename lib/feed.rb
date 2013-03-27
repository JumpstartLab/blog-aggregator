require 'happymapper'
require 'sanitize'

module Blogs

  class Link
    include HappyMapper
    attribute :href, String
  end

  class Author
    include HappyMapper
    element :name, String
  end

  class Entry
    include HappyMapper

    element :title, String
    element :published, Date

    element :link, Link

    def author
      author = Author.new
      author.name = feed.author
      author
    end

    attr_accessor :feed

    def url
      "#{feed.base_url.to_s.gsub(/\/$/,'')}#{link.href}"
    end

    element :raw_summary, String, tag: "summary"

    def summary
      Sanitize.clean(raw_summary).strip
    end

    element :content, String
  end

  class Feed
    include HappyMapper

    element :title, String
    element :subtitle, String

    attr_accessor :author, :base_url

    has_many :raw_entries, Entry

    has_many :links, Link

    # def base_url
    #   links.first.href
    # end

    def entries
      raw_entries.each {|entry| entry.feed = self }
    end
  end


end