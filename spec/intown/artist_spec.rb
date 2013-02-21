require 'spec_helper'

describe Intown::Artist do
  let(:response) {
    stub(:code => 200,
         :body => '{
                    "upcoming_events_count":0,
                    "thumb_url":"http:\/\/www.bandsintown.com\/Nirvana\/photo\/small.jpg",
                    "name": "Nirvana",
                    "image_url":"http:\/\/www.bandsintown.com\/Nirvana\/photo\/medium.jpg",
                    "mbid":"ea5883b7-68ce-48b3-b115-61746ea53b8c",
                    "facebook_tour_dates_url":"http:\/\/bnds.in\/zTPiUu"
                  }'
        )
  }

  context "searching by name" do
    it "should put the name in the artist url" do
      Intown::Artist.should_receive(:get).with(/\/artists\/Nirvana/, anything).and_return(response)
      Intown::Artist.fetch(:name => "Nirvana")
    end
  end

  context "searching by name with spaces" do
    it "should url encode the spaces" do
      Intown::Artist.should_receive(:get).with(/\/artists\/Foo%20Fighters/, anything).and_return(response)
      Intown::Artist.fetch(:name => "Foo Fighters")
    end
  end

  context "searching by musicbrainz id" do
    it "should format the musicbrainz id in the url" do
      Intown::Artist.should_receive(:get).with(/\/artists\/mbid_1234567890abcd/, anything).and_return(response)
      Intown::Artist.fetch(:mbid => "1234567890abcd")
    end
  end

  context "searching with invalid params" do
    it "should raise an argument error" do
      expect { Intown::Artist.fetch(:foo_bar => "baz") }.to raise_error ArgumentError
    end
  end

end
