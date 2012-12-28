class CreateAccountDomain < ActiveRecord::Migration
  def up
    create_table :account_domains, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :account_id
      t.column :url, :string
      t.column :verified, :boolean
      t.column :primary, :boolean
    end
    add_index :account_domains, :id
  end

  def down
    drop_table :account_domains
  end
end
