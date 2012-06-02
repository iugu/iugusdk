module Iugusdk
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      # TODO: Rewrite
      def search_user_account
        return false unless signed_in?
        return false unless current_user
        find_user_account = nil

        # Procurar conta pelo Cookie
        if cookies[:last_used_account_id]
          account = Account.find( cookies[:last_used_account_id] ) 
        else
        # Selecionar a primeira conta do usuario
          account = current_user.account_users.try(:first).try(:account)
        end
        return false unless account

        # Verificar se tem permissão
        user_account = account.account_users.where( :user_id => current_user.id ).first

        # Se nao tiver permissao tentar buscar outra conta
        if user_account.nil?
          account = current_user.account_users.try(:first).try(:account)
          return false unless account
          user_account = account.account_users.where( :user_id => current_user.id ).first
        end

        return false if user_account.nil?
        user_account
      end

      def current_user_account
        @current_user_account ||= search_user_account
      end
    end
  end
end
