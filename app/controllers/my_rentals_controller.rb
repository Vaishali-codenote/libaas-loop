class MyRentalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rentals_as_renter = current_user.rentals_as_renter.includes(:listing, :owner)
    @rentals_as_owner = current_user.rentals_as_owner.includes(:listing, :renter)
  end
end
