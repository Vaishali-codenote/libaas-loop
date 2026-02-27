class Rental < ApplicationRecord
  belongs_to :listing
  belongs_to :renter, class_name: "User"
  belongs_to :owner, class_name: "User"

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true
  validate :dates_are_valid
  validate :listing_available_for_dates

  enum status: { pending: "pending", approved: "approved", rejected: "rejected", active: "active", completed: "completed", cancelled: "cancelled" }

  scope :active, -> { where(status: [:active, :approved]) }
  scope :pending, -> { where(status: :pending) }

  after_create_commit -> { broadcast_append_to "rentals" }
  after_update_commit -> { broadcast_replace_to "rentals" }
  after_destroy_commit -> { broadcast_remove_to "rentals" }

  def total_price
    return 0 unless start_date && end_date && listing.price_per_day

    ((end_date - start_date).to_i + 1) * listing.price_per_day
  end

  def refund_issued?
    refund_issued_at.present?
  end

  private

  def dates_are_valid
    if start_date && end_date && end_date < start_date
      errors.add(:end_date, "must be on or after start date")
    end

    if start_date && start_date < Date.today
      errors.add(:start_date, "cannot be in the past")
    end
  end

  def listing_available_for_dates
    return unless start_date && end_date

    overlapping = listing.rentals.where(status: [:pending, :approved, :active]).where.not(id: id).select do |r|
      r.start_date <= end_date && r.end_date >= start_date
    end

    errors.add(:base, "Listing is not available for the selected dates") if overlapping.any?
  end
end
