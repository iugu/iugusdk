class CreateAccountRoles < ActiveRecord::Migration
  def up
    create_table :account_roles do |t|
      t.column :name, :string
      t.column :account_user_id, :integer
    end
  end

  def down
    drop_table :account_roles
  end
end
