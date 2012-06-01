class CreateAccountUsers < ActiveRecord::Migration
  def up
    create_table :account_users do |t|
      t.column :account_id, :integer
      t.column :user_id, :integer
    end
  end

  def down
    drop_table :account_users
  end
end
