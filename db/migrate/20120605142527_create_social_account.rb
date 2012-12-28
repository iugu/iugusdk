class CreateSocialAccount < ActiveRecord::Migration
  def up
    create_table :social_accounts, id: false do |t|
      t.uuid :id, primary_key: true
      t.string :social_id
      t.uuid :user_id
      t.column :provider, :string
      t.column :token, :string
      t.column :secret, :string
    end
    add_index :social_accounts, :id
  end

  def down
    drop_table :social_accounts
  end
end
