require 'spec_helper'

describe SettingsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.code.should == "302"
    end
  end

end
