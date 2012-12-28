class CreateAccount < ActiveRecord::Migration
  def up
    create_table :accounts, id: false do |t|
      t.uuid :id, primary_key: true
      t.timestamps
    end
    add_index :accounts, :id
  end

  def down
    drop_table :accounts
  end
end
