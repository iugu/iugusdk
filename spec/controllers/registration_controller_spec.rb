require 'spec_helper'

describe Iugu::RegistrationsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "try first" do
    context "enable_guest_user == true" do
      before(:each) do
        IuguSDK::enable_guest_user = true
        post :try_first
      end

      it { flash.now[:notice].should == I18n.t("iugu.notices.guest_login") }
    end

    context "enable_guest_user == false" do
      before(:each) do
        IuguSDK::enable_guest_user = false
      end

      it 'should raise routing error' do
        lambda {
          post :try_first
        }.should raise_error ActionController::RoutingError
      end
    end

  end

  context "new" do
    context "when enable_subscription_features == true and default_subscription_name = nil " do
      before(:each) do
        IuguSDK::enable_subscription_features = true
        IuguSDK::default_subscription_name = nil
      end
      it 'should redirect to pricing' do
        get :new
        response.should redirect_to pricing_index_path
      end
    end

  end

end
