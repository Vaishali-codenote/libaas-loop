class Admin::DashboardController < Admin::BaseController
  def index
    @total_users = User.count
    @total_listings = Listing.count
    @total_active_rentals = Rental.where(status: %w[active approved]).count
    @pending_listings_count = Listing.pending_approval.count
    @total_revenue = Rental.where(status: %w[active completed]).includes(:listing).sum { |rental| rental.total_price.to_f }

    @recent_users = User.order(created_at: :desc).limit(8)
    @recent_listings = Listing.includes(:user).order(created_at: :desc).limit(8)
  end
end
