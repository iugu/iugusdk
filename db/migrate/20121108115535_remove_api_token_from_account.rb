class RemoveApiTokenFromAccount < ActiveRecord::Migration
  def up
    remove_column :accounts, :api_token
  end

  def down
    add_column :accounts, :api_token, :string
  end
end
