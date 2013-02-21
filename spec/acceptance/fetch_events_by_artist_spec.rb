require 'spec_helper'

describe Tourbus::Event do
  before :each do
    Tourbus.configure do |c|
      c.app_id = "test"
    end
  end
  context "Fetching events for an unknown band" do
    it "should return nil" do
      VCR.use_cassette("fetch events for unknown band") do
        events = Tourbus::Event.list(:name => "GoobleGobble124")
        puts events
        events.should be_nil
      end
    end
  end

  context "Fetching events for an unknown band" do
    it "should return nil" do
      VCR.use_cassette("fetch events for known band") do
        events = Tourbus::Event.list(:name => "Blame Sally")
        puts events
      end
    end
  end
end
