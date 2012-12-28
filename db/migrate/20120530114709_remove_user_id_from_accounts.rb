class RemoveUserIdFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :user_id
  end

  def down
    add_column :accounts, :user_id, :binary, :limit => 16
  end
end
