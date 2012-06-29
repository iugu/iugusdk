class CreateUserInvitations < ActiveRecord::Migration
  def up
    create_table :user_invitations do |t|
      t.column :invited_by, :integer
      t.column :email, :string
      t.column :sent_at, :datetime
      t.column :account_id, :integer
    end
  end

  def down
    drop_table :user_invitations
  end
end
