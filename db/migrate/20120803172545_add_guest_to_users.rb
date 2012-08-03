class AddGuestToUsers < ActiveRecord::Migration
  def up
    add_column :users, :guest, :boolean
  end

  def down
    remove_column :users, :guest
  end
end
