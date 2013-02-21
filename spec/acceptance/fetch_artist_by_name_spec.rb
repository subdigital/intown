require 'spec_helper'

describe Tourbus::Artist do

  context "without configuring an app id" do
    before do
      Tourbus.configure {|c| c.app_id = nil}
    end
    it "should raise an error if the app id param is not set" do
      VCR.use_cassette("fetch_artist_no_app_id_set") do
        expect { Tourbus::Artist.fetch(:name => "foobar") }.to raise_error Tourbus::InvalidRequestError
      end
    end
  end

  context "with an app id configured" do
    before do
      Tourbus.configure {|c| c.app_id = "test"}
    end

    it "should return nil for unknown artists" do
      VCR.use_cassette("find_unknown_artist") do
        Tourbus::Artist.fetch(:name => "Ishouldnotexist").should be_nil
      end
    end

    it "should be fetched by name" do
      VCR.use_cassette("find_artist_by_name") do
        artist = Tourbus::Artist.fetch(:name => "My Morning Jacket")
        artist.name.should == "My Morning Jacket"
      end
    end
  end

end
