class AddTokenToUserInvitations < ActiveRecord::Migration
  def up
    add_column :user_invitations, :token, :string
  end
  def down
    remove_column :user_invitations, :token
  end
end
