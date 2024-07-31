class TrainStation < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :osm_id, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
  validates :image, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..(5.megabytes) }
end
