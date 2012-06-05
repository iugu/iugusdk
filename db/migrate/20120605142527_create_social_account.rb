class CreateSocialAccount < ActiveRecord::Migration
  def up
    create_table :social_accounts do |t|
      t.column :social_id, :integer
      t.column :user_id, :integer
      t.column :provider, :string
      t.column :token, :string
      t.column :secret, :string
    end
  end

  def down
    drop_table :social_accounts
  end
end
