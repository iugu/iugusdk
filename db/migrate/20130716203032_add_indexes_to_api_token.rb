class AddIndexesToApiToken < ActiveRecord::Migration
  def up
    add_index :api_tokens, :token
    add_index :api_tokens, [ :tokenable_id, :tokenable_type ], length: { tokenable_id: 16 }
  end

  def down
    remove_index :api_tokens, column: :token
    remove_index :api_tokens, column: [ :tokenable_id, :tokenable_type ]
  end
end
