module Iugusdk
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      def search_user_account( account_id )
        return false unless signed_in? and current_user
        current_user.account_users.where( :account_id => account_id ).try(:first)
      end

      def current_user_account
        @current_user_account ||= search_user_account( session[:current_account_id] )
      end

      def select_account( account_id=nil )
        account_id = account_id.id if account_id.is_a? Account
        selected_account = current_user.accounts.where( [ "accounts.id = ? or accounts.id = ?", account_id, cookies[:last_used_account_id] ] ).first || current_user.accounts.first
        if selected_account
          cookies[:last_used_account_id] = { :value => selected_account.id, :expires => 365.days.from_now }
          session[ :current_account_id ] = selected_account.id
        end
        selected_account
      end
    end
  end
end
