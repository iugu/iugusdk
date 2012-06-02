module Iugusdk
  class Engine < Rails::Engine

    initializer 'iugusdk.action_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        include Iugusdk::Controllers::Helpers
      end
    end

  end
end
