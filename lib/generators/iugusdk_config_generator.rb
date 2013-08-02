class IugusdkConfigGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  argument :app_name, :type => :string, default: "myapp_name"

  def copy_initializer
    template "iugusdk.rb", "config/initializers/iugusdk.rb"
  end

  def copy_account_roles
    copy_file "account_roles.yml", "config/account_roles.yml"
  end
  
end
