class Listing < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :title, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :price_per_day, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_many :rentals, dependent: :destroy

  enum status: { available: "available", rented: "rented", unavailable: "unavailable" }
end
