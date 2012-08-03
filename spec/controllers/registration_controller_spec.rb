require 'spec_helper'

describe Iugu::RegistrationsController do

  context "try first" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :try_first
    end

    it { flash.now[:notice].should == I18n.t("iugu.notices.guest_login") }
  
  end
  
end
