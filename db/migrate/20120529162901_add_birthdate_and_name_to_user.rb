class AddBirthdateAndNameToUser < ActiveRecord::Migration

  def up
    add_column :users, :birthdate, :date
    add_column :users, :name, :string
  end

  def down
    remove_column :users, :birthdate
    remove_column :users, :name
  end
end
