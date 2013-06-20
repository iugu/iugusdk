class ChangeAccountSubscriptionIdToUuid < ActiveRecord::Migration
  def up
    change_column :accounts, :subscription_id, :binary, limit: 16
  end

  def down
    change_column :accounts, :subscription_id, :integer
  end
end
