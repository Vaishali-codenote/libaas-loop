class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, admin: 1 }

  has_many :listings, dependent: :destroy
  has_many :rentals_as_renter, class_name: "Rental", foreign_key: :renter_id, dependent: :destroy
  has_many :rentals_as_owner, class_name: "Rental", foreign_key: :owner_id, dependent: :destroy

  validates :name, presence: true

  def active_for_authentication?
    super && !blocked?
  end

  def inactive_message
    blocked? ? :locked : super
  end

  def total_earnings
    rentals_as_owner.where(status: %w[active completed]).sum { |rental| rental.total_price.to_f }
  end
end
