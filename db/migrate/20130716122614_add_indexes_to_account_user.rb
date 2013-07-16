class AddIndexesToAccountUser < ActiveRecord::Migration
  def up
    add_index :account_users, :user_id
    add_index :account_users, :account_id
  end

  def down
    remove_index :account_users, column: :user_id
    remove_index :account_users, column: :account_id
  end
end
