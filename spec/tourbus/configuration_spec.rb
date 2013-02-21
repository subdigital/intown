require 'spec_helper'

describe Tourbus::Configuration do
  it "should set an app_id" do
    Tourbus.configure do |config|
      config.app_id = "my_app"
    end

    Tourbus.configuration.app_id.should == "my_app"
  end
end
