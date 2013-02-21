require 'spec_helper'

describe Intown::Configuration do
  it "should set an app_id" do
    Intown.configure do |config|
      config.app_id = "my_app"
    end

    Intown.configuration.app_id.should == "my_app"
  end
end
