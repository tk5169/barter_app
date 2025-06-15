# db/migrate/20250606000000_create_messages.rb
class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text    :content,   null: false
      t.integer :parent_id, index: true, foreign_key: { to_table: :messages }

      t.timestamps
    end
  end
end
