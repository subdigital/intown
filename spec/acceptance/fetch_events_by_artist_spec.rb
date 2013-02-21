require 'spec_helper'

describe Intown::Event do
  before :each do
    Intown.configure do |c|
      c.app_id = "test"
    end
  end
  context "Fetching events for an unknown band" do
    it "should return nil" do
      VCR.use_cassette("fetch events for unknown band") do
        events = Intown::Event.list(:name => "GoobleGobble124")
        events.should be_nil
      end
    end
  end

  context "Fetching events for an unknown band" do
    it "should return nil" do
      VCR.use_cassette("fetch events for known band") do
        events = Intown::Event.list(:name => "Blame Sally")
        events.length.should >= 0
      end
    end
  end
end
