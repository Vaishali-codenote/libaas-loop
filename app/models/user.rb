class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :listings, dependent: :destroy
  has_many :rentals_as_renter, class_name: "Rental", foreign_key: :renter_id, dependent: :destroy
  has_many :rentals_as_owner, class_name: "Rental", foreign_key: :owner_id, dependent: :destroy

  validates :name, presence: true

  def admin?
    role == "admin"
  end
end
