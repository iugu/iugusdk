class CreateApiToken < ActiveRecord::Migration
  def up
    create_table :api_tokens do |t|
      t.column :token, :string
      t.column :description, :string
      t.column :api_type, :string
      t.references :tokenable, :polymorphic => true
      t.timestamps
    end
  end

  def down
    drop_table :api_tokens
  end
end
