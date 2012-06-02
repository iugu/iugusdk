require 'spec_helper'

describe AccountController do
  include Devise::TestHelpers

  describe "GET 'index'" do
    it "returns false because need authentication" do
      get 'index'
      response.should_not be_success
    end
  end

end
