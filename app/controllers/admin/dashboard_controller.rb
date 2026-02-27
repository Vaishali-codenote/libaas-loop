class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    @total_users = User.count
    @total_listings = Listing.count
    @total_rentals = Rental.count
    @active_rentals = Rental.where(status: [:active, :approved]).count
    @completed_rentals = Rental.where(status: :completed).count
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_listings = Listing.order(created_at: :desc).limit(5)
    @recent_rentals = Rental.order(created_at: :desc).limit(5)
  end
end
