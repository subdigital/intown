require 'spec_helper'

describe Intown::Artist do
  describe "valid response" do
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
    
    context "searching by name with periods in the name" do
      it "should URL encode the period" do
        Intown::Artist.should_receive(:get).with(/\/artists\/Jr%2E%20Doc/, anything).and_return(response)
        Intown::Artist.fetch(:name => "Jr. Doc")        
      end
    end
    
    context "searching by name with a /" do
      it "should double encode the slash" do
        Intown::Artist.should_receive(:get).with(/\/artists\/Is%252FIs/, anything).and_return(response)
        Intown::Artist.fetch(:name => "Is/Is")
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
  
  describe "invalid response" do
    let(:status_code) { nil }
    let(:response_body) { '{"errors":["app_id param is required"]}' }
    let(:response) {
      stub(:body => response_body, 
           :code => status_code)
    }

    before do
      Intown::Artist.should_receive(:get).and_return(response)
    end

    context "500 Internal Server Error" do
      let(:status_code) { 500 }
      it_behaves_like 'error', Intown::InternalServerError
    end

    context "502 Bad Gateway" do
      let(:status_code) { 502 }
      it_behaves_like 'error', Intown::BadGatewayError
    end

    context "404 Not Found" do
      let(:status_code) { 404 }
      it_behaves_like 'error', Intown::InvalidRequestError
    end

    context "406 Not Acceptable" do
      let(:status_code) { 406 }
      it_behaves_like 'error', Intown::InvalidRequestError
    end
  end

end
