class AddSubdomainToAccount < ActiveRecord::Migration
  def up
    add_column :accounts, :subdomain, :string
  end

  def down
    remove_column :accounts, :subdomain
  end
end
