class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.string     :title,       null: false
      t.text       :description, null: false
      t.references :user,        null: false, foreign_key: true
      t.datetime :expires_at
      t.timestamps
    end
  end
end
