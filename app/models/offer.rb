class Offer < ApplicationRecord
  belongs_to :item
  belongs_to :offered_by, class_name: "User"
  has_many :replies, dependent: :destroy
end
