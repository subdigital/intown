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
end
