require 'spec_helper'

describe Blogs::Feed do

  let(:content) { File.read(File.join(File.dirname(__FILE__),"fixtures","feed.xml")) }
  let(:subject) { described_class.parse content }

  its(:title) { should eq "Blair Builds" }
  its(:subtitle) { should eq "My Notes about Ruby and gSchool" }
  describe "#entries" do
    it "is an array of entries found on the website" do
      expect(subject.entries).to be_kind_of(Array)
    end

    it "returns entry objects" do
      expect(subject.entries.first).to be_kind_of(Blogs::Entry)
    end
  end

end