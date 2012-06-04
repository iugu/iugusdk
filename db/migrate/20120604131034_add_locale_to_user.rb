class AddLocaleToUser < ActiveRecord::Migration
  def up
    add_column :users, :locale, :string
  end

  def down
    remove_column :users, :locale
  end
end
