class AddInvitableToUser < ActiveRecord::Migration
  def change
    add_column :users, :invitation_token, :string, :limit => 60
    add_column :users, :invitation_sent_at, :datetime
    add_column :users, :invitation_accepted_at, :datetime
    add_column :users, :invitation_limit, :integer
    add_column :users, :invited_by_id, :integer
    add_column :users, :invited_by_type, :string
    add_index :users, :invitation_token, :unique => true
  end
end
