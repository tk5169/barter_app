class CreateOffers < ActiveRecord::Migration[8.0]
  def change
    create_table :offers do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :offered_by_id
      t.text :offered_item_text
      t.string :status
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
