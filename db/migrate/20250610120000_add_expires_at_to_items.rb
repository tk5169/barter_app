class AddExpiresAtToItems < ActiveRecord::Migration[6.1]
  def change
    # pgcrypto 拡張は、Change メソッドの中で呼び出す
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    add_column :items, :expires_at, :datetime
  end
end
