class HomeController < ApplicationController
  def index
    @featured_listings = Listing.includes(:user).where(status: :available, approval_status: :approved).limit(6)
  end
end
