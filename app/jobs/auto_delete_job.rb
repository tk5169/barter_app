class AutoDeleteJob < ApplicationJob
  queue_as :default

  def perform(item_id)
    item = Item.find_by(id: item_id)
    return unless item && item.expires_at && Time.current >= item.expires_at

    item.destroy
  end
end
