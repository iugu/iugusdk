module IuguSDK
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

      def select_account( resource, account_id=nil )
        if account_id == nil
          account_id = cookies[:last_used_account_id] if cookies[:last_used_account_id]
        end
        selected_account = resource.default_account( account_id )
        if selected_account
          cookies[:last_used_account_id] = { :value => selected_account.id, :expires => 365.days.from_now }
          session[ :current_account_id ] = selected_account.id
        end
        selected_account
      end

      def is_active?(control, action="", id="")
        if id == ""
          if action == ""
            return true if controller_name == control.gsub("/", "")
          else
            return true if controller_name == control.gsub("/", "") && action_name == action
          end
        else
          return true if controller_name == control.gsub("/", "") && action_name == action && id == params[:id]
        end
        return false
      end

      def body_classes
        [controller_name,action_name,'page-' + controller_name + '-' + action_name]
      end
    end
  end
end
