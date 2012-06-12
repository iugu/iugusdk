class SetLocale < ActiveRecord::Migration
  def change
    User.where(:locale => nil).update_all("locale = 'en'")
  end

end
