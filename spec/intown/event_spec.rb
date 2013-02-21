require 'spec_helper'

describe Intown::Event do
  let(:response) {
    stub(:code => 200,
         :body => '{"foo":"bar"}')
  }

  context "searching by artist id" do
    it "should format the proper artist term in the url" do
      Intown::Event.should_receive(:get).with(/artists\/Radiohead\/events/, anything).and_return(response)
      Intown::Event.list(:name => "Radiohead")
    end
  end

  context "Searching by date range" do
    before :each do
      Intown::Event.should_receive(:get).with(anything, hash_including(expected_params)).and_return(response)
    end

    context "single date" do
      let(:expected_params) {{ :date => '2013-03-02' }}
      let(:input_params)    {{ :name => "Radiohead", :date => Time.new(2013, 3, 2) }}
      it "should format the date in the url" do
        Intown::Event.list(input_params)
      end
    end

    context "date range" do
      let(:expected_params) {{ :date => '2013-03-02,2013-03-08' }}
      let(:input_params)    {{ :name => "Radiohead", :from => Time.new(2013, 3, 2), :to => Time.new(2013, 3, 8)}}
      it "should format the date range from to/from date params" do
        Intown::Event.list(input_params)
      end
    end

    context "upcoming" do
      let(:expected_params) {{ :date => 'upcoming' }}
      let(:input_params)    {{ :name => "Radiohead", :upcoming => true}}
      it "should set the date parameter to upcoming" do
        Intown::Event.list(input_params)
      end
    end

    context "all" do
      let(:expected_params) {{ :date => 'all' }}
      let(:input_params)    {{ :name => "Radiohead", :all => true}}
      it "should set the date parameter to all" do
        Intown::Event.list(input_params)
      end
    end
  end
end
