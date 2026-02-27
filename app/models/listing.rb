class Listing < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :price_per_day, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :image_name, presence: true

  has_many :rentals, dependent: :destroy

  enum status: { available: "available", rented: "rented", unavailable: "unavailable" }
  enum approval_status: { pending: "pending", approved: "approved", rejected: "rejected" }

  before_validation :normalize_image_name
  after_update_commit -> { broadcast_replace_to "listings" }

  scope :pending_approval, -> { where(approval_status: :pending) }

  private

  def normalize_image_name
    self.image_name = image_name.to_s.downcase.presence || "sample1.jpg"
  end
end
