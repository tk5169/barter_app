class Item < ApplicationRecord
  belongs_to :user
  has_many :offers, dependent: :destroy
  has_one_attached :image
  
  after_create :schedule_auto_delete, if: -> { expires_at.present? }

  private

  def schedule_auto_delete
    AutoDeleteJob.set(wait_until: expires_at).perform_later(id)
  end
  
end
