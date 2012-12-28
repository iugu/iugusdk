class AddNameAndSubscriptionIdAndUserIdToAccount < ActiveRecord::Migration
  def up
    add_column :accounts, :name, :string
    add_column :accounts, :subscription_id, :integer
    add_column :accounts, :user_id, :binary, :limit => 16
  end

  def down
    remove_column :accounts, :name
    remove_column :accounts, :subscription_id
    remove_column :accounts, :user_id
  end
end
