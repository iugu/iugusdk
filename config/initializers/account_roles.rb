begin
  APP_ROLES = YAML.load_file("#{Rails.root.to_s}/config/account_roles.yml")
rescue
  APP_ROLES = {"roles"=>["owner", "user"], "owner_role"=>"owner", "admin_role" => "owner" }
end
