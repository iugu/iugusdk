class AddApiTokenToAccount < ActiveRecord::Migration
  def up
    add_column :accounts, :api_token, :string
  end

  def down
    remove_column :accounts, :api_token
  end
end
