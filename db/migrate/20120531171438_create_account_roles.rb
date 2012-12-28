class CreateAccountRoles < ActiveRecord::Migration
  def up
    create_table :account_roles, id: false do |t|
      t.uuid :id, primary_key: true
      t.column :name, :string
      t.uuid :account_user_id
    end
    add_index :account_roles, :id
  end

  def down
    drop_table :account_roles
  end
end
