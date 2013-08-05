class WebappGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates/web-app", __FILE__)

  def create_entry_point_route
    line = "::Application.routes.draw do"
    gsub_file 'config/routes.rb', /(#{Regexp.escape(line)})/mi do |match|
      "#{match}\n get 'app(/*path)' => 'entry_point#index'\n"
    end
  end

  def create_entry_point_controller
    copy_file "entry_point_controller.rb", "app/controllers/entry_point_controller.rb"
  end

  def create_entry_point_view
    copy_file "entry_point_view.html.haml", "app/views/entry_point/index.html.haml"
  end

  def create_web_app_directories
    directory "web-app/models", "app/assets/javascripts/web-app/models"
  end

  def create_web_app_config_files
    copy_file "web-app/models.js", "app/assets/javascripts/web-app/models.js"
    copy_file "web-app/usecode.js", "app/assets/javascripts/web-app/usecode.js"
    copy_file "web-app/presenters.js", "app/assets/javascripts/web-app/presenters.js"
    copy_file "web-app/config.js.erb", "app/assets/javascripts/web-app/config.js.erb"
    copy_file "web-app/i18n-languages.js.erb", "app/assets/javascripts/web-app/i18n-languages.js.erb"
    copy_file "web-app/locale/en.yml", "app/assets/javascripts/web-app/locale/en.yml"
    copy_file "web-app/locale/pt-BR.yml", "app/assets/javascripts/web-app/locale/pt-BR.yml"
    copy_file "web-app/usecode/application_controller.js.coffee", "app/assets/javascripts/web-app/usecode/application_controller.js.coffee"
  end

  def create_web_app_storyboard
    copy_file "web-app/usecode/storyboard.js.coffee", "app/assets/javascripts/web-app/usecode/storyboard.js.coffee"
  end

  def create_web_app_sidebar
    copy_file "web-app/usecode/sidebar/sidebar_controller.js.coffee", "app/assets/javascripts/web-app/usecode/sidebar/sidebar_controller.js.coffee"
    copy_file "web-app/presenters/sidebar/sidebar.jst.eco", "app/assets/javascripts/web-app/presenters/sidebar/sidebar.jst.eco"
  end

  def create_web_app_dashboard
    copy_file "web-app/usecode/dashboard/dashboard_controller.js.coffee", "app/assets/javascripts/web-app/usecode/dashboard/dashboard_controller.js.coffee"
    copy_file "web-app/presenters/dashboard/index.jst.eco", "app/assets/javascripts/web-app/presenters/dashboard/index.jst.eco"
  end

end
