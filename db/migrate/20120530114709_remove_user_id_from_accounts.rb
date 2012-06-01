class RemoveUserIdFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :user_id
  end

  def down
    add_column :accounts, :user_id, :integer
  end
end
