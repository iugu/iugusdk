module IuguSDK
  class Engine < Rails::Engine

    initializer 'iugusdk.action_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        include IuguSDK::Controllers::Helpers
        helper_method "search_user_account", "current_user_account", "is_active?", "body_classes"
        ActionController::Base.send(:include, IuguSDKBaseController)
      end
    end

  end
end
