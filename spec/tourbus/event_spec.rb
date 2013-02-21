require 'spec_helper'

describe Tourbus::Event do
  let(:response) {
    stub(:code => 200,
         :body => '{"foo":"bar"}')
  }

  context "searching by artist id" do
    it "should format the proper artist term in the url" do
      Tourbus::Event.should_receive(:get).with(/artists\/Radiohead\/events/, anything).and_return(response)
      Tourbus::Event.list(:name => "Radiohead")
    end
  end

  context "Searching by date range" do
    before :each do
      Tourbus::Event.should_receive(:get).with(anything, hash_including(expected_params)).and_return(response)
    end

    context "single date" do
      let(:expected_params) {{ :date => '2013-03-02' }}
      it "should format the date in the url" do
        params = { :name => "Radiohead", :date => Time.new(2013, 3, 2) }
        Tourbus::Event.list(params)
      end
    end

    context "date range" do
      let(:expected_params) {{ :date => '2013-03-02,2013-03-08' }}
      it "should format the date range from to/from date params" do
        params = {:name => "Radiohead", :from => Time.new(2013, 3, 2), :to => Time.new(2013, 3, 8)}
        Tourbus::Event.list(params)
      end
    end
  end
end
