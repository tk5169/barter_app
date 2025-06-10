enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

class AddExpiresAtToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :expires_at, :datetime
  end
end
