require 'spec_helper'

describe SettingsController do
  include Devise::TestHelpers

  describe "GET 'index'" do
    it "returns false because need authentication" do
      get 'index'
      # response.code.should == "302"
      response.should_not be_success
    end
  end

end
