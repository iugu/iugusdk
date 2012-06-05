class AuthenticableController < ApplicationController
  private
    def sign_in_and_select_account_for( user )
      flash[:notice] = "devise.sessions.signed_in"
      sign_in user
      select_account
    end
end
