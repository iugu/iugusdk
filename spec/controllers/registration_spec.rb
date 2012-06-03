require 'spec_helper'

describe RegistrationController do

  before(:each) do
    @credentials = { :email => "teste@teste.com", :password => "123456" }
  end

  context "with a user signed in" do
    login_as_user
    it_should_redirect_to_app_main_for_actions :new
  end

  context "action create" do

    context "after a valid user signup" do
      before { post :create, :user => @credentials }
      it { should redirect_to( IuguSDK::app_main_url ) }
    end

    context "after a invalid user signup" do
      before { post :create, :user => { :email => "absdf" } }
      it { should render_template('iugu/signup') }
    end

  end

end
