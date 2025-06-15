class Request < ApplicationRecord
  belongs_to :user
  has_one_attached :image   # 画像添付を許可
  
  after_create :schedule_auto_delete, if: -> { expires_at.present? }

  validates :title, presence: true
  
    private

    def schedule_auto_delete
      AutoDeleteJob.set(wait_until: expires_at).perform_later(self.id)
    end
end
