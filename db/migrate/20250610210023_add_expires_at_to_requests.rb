class AddExpiresAtToRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :requests, :expires_at, :datetime
  end
end
