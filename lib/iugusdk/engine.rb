module Iugusdk
  class Engine < Rails::Engine

    initializer 'iugusdk.action_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        include Iugusdk::Controllers::Helpers
        helper_method "search_user_account", "current_user_account"
      end
    end

  end
end
