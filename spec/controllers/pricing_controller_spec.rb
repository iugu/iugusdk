require 'spec_helper'

describe Iugu::PricingController do
  login_as_user
  describe "unless iws_api_key" do
    before do
      IuguSDK::iws_api_key = nil
    end
    it 'should raise routing error' do
      lambda {
        get :index
      }.should raise_error ActionController::RoutingError
    end
  end
  
end
