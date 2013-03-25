require 'spec_helper'

describe Blogs::Entry do

  let(:content) { File.read(File.join(File.dirname(__FILE__),"fixtures","feed_with_simple_entry.xml")) }
  let(:feed) do
    feed = Blogs::Feed.parse content
    feed.author = "Blair"
    feed.base_url = "http://blairbuilds.herokuapp.com/"
    feed
  end

  let(:subject) { feed.entries.first }

  its(:title) { should eq "TITLE" }
  its(:published) { should eq Date.parse("2013-03-16T17:12:00Z") }
  its(:url) { should eq "http://blairbuilds.herokuapp.com/2013/03/16/title.html" }
  its(:summary) { should eq "SUMMARY  Bird Dog" }
  its(:content) { should eq "SUMMARY + CONTENT" }

end