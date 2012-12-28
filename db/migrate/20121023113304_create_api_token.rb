class CreateApiToken < ActiveRecord::Migration
  def up
    create_table :api_tokens, id: false do |t|
      t.uuid :id, primary_key: true
      t.column :token, :string
      t.column :description, :string
      t.column :api_type, :string
      t.uuid :tokenable_id
      t.column :tokenable_type, :string
      t.timestamps
    end
    add_index :api_tokens, :id
  end

  def down
    drop_table :api_tokens
  end
end
