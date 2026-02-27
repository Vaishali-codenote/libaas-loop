class MyListingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @listings = current_user.listings.order(created_at: :desc)
    @owner_rented_items = Rental
      .includes(:listing, :renter)
      .where(owner: current_user)
      .where.not(renter_id: current_user.id)
      .where(status: %w[active completed cancelled])
      .order(start_date: :desc)
  end
end
