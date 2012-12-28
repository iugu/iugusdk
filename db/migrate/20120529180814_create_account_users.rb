class CreateAccountUsers < ActiveRecord::Migration
  def up
    create_table :account_users, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :account_id
      t.uuid :user_id
    end

    add_index :account_users, :id
  end

  def down
    drop_table :account_users
  end
end
