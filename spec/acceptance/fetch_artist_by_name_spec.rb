require 'spec_helper'

describe Intown::Artist do

  context "without configuring an app id" do
    before do
      Intown.configure {|c| c.app_id = nil}
    end
    it "should raise an error if the app id param is not set" do
      VCR.use_cassette("fetch_artist_no_app_id_set") do
        expect { Intown::Artist.fetch(:name => "foobar") }.to raise_error Intown::InvalidRequestError
      end
    end
  end

  context "with an app id configured" do
    before do
      Intown.configure {|c| c.app_id = "test"}
    end

    it "should return nil for unknown artists" do
      VCR.use_cassette("find_unknown_artist") do
        Intown::Artist.fetch(:name => "Ishouldnotexist").should be_nil
      end
    end

    it "should be fetched by name" do
      VCR.use_cassette("find_artist_by_name") do
        artist = Intown::Artist.fetch(:name => "My Morning Jacket")
        artist.name.should == "My Morning Jacket"
        artist.upcoming_events_count.should_not be_nil
        artist.image_url.should_not be_nil
        artist.mbid.should_not be_nil
      end
    end
  end

  context "with slashes in the name" do
    before do
      Intown.configure {|c| c.app_id = "test"}
    end

    it "should return nil for unknown artists" do
      VCR.use_cassette("find_unknown_artist_with_slashes") do
        Intown::Artist.fetch(:name => "Fake/Artist/Name").should be_nil
      end
    end
    it "should be fetched by name" do
      VCR.use_cassette("find_artist_by_name_with_slashes") do
        artist = Intown::Artist.fetch(:name => "Be/Non")
        artist.name.should == "Be/Non"
        artist.upcoming_events_count.should_not be_nil
        artist.image_url.should_not be_nil
        artist.mbid.should_not be_nil
      end
    end
  end

  context "with periods in the name" do
    it "should return nil for unknown artists" do
      VCR.use_cassette("find_unknown_artist_with_periods") do
        Intown::Artist.fetch(:name => "Fake.Artist.Name").should be_nil
      end
    end
    it "should be fetched by name" do
      VCR.use_cassette("find_artist_by_name_with_periods") do
        artist = Intown::Artist.fetch(:name => "will.i.am")
        artist.name.should == "will.i.am"
        artist.upcoming_events_count.should_not be_nil
        artist.image_url.should_not be_nil
        artist.mbid.should_not be_nil
      end
    end
  end

end
