class Rental < ApplicationRecord
  belongs_to :listing
  belongs_to :renter, class_name: "User"
  belongs_to :owner, class_name: "User"

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true

  enum status: { pending: "pending", approved: "approved", rejected: "rejected", active: "active", completed: "completed", cancelled: "cancelled" }

  scope :active, -> { where(status: [:active, :approved]) }
  scope :pending, -> { where(status: :pending) }

  def total_price
    return 0 unless start_date && end_date && listing.price_per_day
    (end_date - start_date).to_i * listing.price_per_day
  end
end
