module IuguSDK
  class Engine < Rails::Engine

    initializer "iugusdk.load_app_root" do |app|
      app.config.assets.precompile += %w( iugu-sdk.css settings.css )
       IuguSDK.app_root = app.root
       app.class.configure do
         config.paths['db/migrate'] += IuguSDK::Engine.paths['db/migrate'].existent
       end

       #app.config.middleware.insert_before( app.config.session_store, SessionParameterMiddleware, app.config.session_options[:key])
       # app.middleware.insert_before( app.config.session_store, IuguSDK::SessionParameterMiddleware, app.config.session_options[:key])
       # config.middleware.insert_before( ActionDispatch::Session::CookieStore, SessionParameterMiddleware, app.config.session_options[:key] )

    end

    initializer 'iugusdk.action_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        include IuguSDK::Controllers::Helpers
        helper_method "search_user_account", "current_user_account", "is_active?", "body_classes", "current_account", "get_compatible_locale"
        ActionController::Base.send(:include, IuguSDKBaseController)
      end
    end

  end
end
