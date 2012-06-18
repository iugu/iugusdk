require 'spec_helper'

describe ProfileController do

  context "index" do

    login_as_user

    before do
      get :index
    end

    it { response.should render_template 'iugu/settings/profile' }
  
  end

  context "update" do

    login_as_user

    before do
      post :update, :user => { :name => "Testname" }
    end

    it { response.should render_template 'iugu/settings/profile' }

     context "with errors" do
        login_as_user

        before do
          post :update, :user => { :password => "aaaaaaaaaaaaaa", :password_confirmation => "bbbbbbbbbbbbbb" }
        end

        it { flash[:error].should_not be_nil }
     
     end
  
  end
end
