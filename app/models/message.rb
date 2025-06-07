# app/models/message.rb
class Message < ApplicationRecord
  # 自己結合の設定
  belongs_to :parent, class_name: "Message", optional: true
  has_many   :replies, class_name: "Message", foreign_key: :parent_id, dependent: :destroy

  validates :content, presence: true
end
