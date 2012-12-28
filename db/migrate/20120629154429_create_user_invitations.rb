class CreateUserInvitations < ActiveRecord::Migration
  def up
    create_table :user_invitations, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :invited_by
      t.column :email, :string
      t.column :sent_at, :datetime
      t.uuid :account_id
    end
    add_index :user_invitations, :id
  end

  def down
    drop_table :user_invitations
  end
end
