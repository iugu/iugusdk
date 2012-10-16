module IuguSDK
  class Engine < Rails::Engine

    initializer "iugusdk.load_app_root" do |app|

       IuguSDK.app_root = app.root

    end

    initializer 'iugusdk.action_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        include IuguSDK::Controllers::Helpers
        helper_method "search_user_account", "current_user_account", "is_active?", "body_classes", "current_account"
        ActionController::Base.send(:include, IuguSDKBaseController)
      end
    end

  end
end
