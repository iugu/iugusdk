module ControllerMacros
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def it_should_require_login_for_actions(*actions)
      actions.each do |action|
        it "#{action} should redirect if no user signed in" do
          get action
          response.should_not be_success
        end
      end
    end

    def it_should_redirect_to_app_main_for_actions(*actions)
      actions.each do |action|
        it "#{action} should redirect if no user signed in" do
          get action
          response.should redirect_to IuguSDK::app_main_url
        end
      end
    end

    def login_as_user
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user = @user if @user
        if user.nil?
          user = Fabricate(:user, :email => "teste@teste.com", :password => "123456", :password_confirmation => "123456" )
          @user = user
        end
        account = Fabricate(:account)
        account.account_users << Fabricate(:account_user, :user => user)
        sign_in user
        select_account user
      end
    end
  end

end
