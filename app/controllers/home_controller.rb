class HomeController < ApplicationController
  def index
    @featured_listings = Listing.includes(:user).where(status: :available).limit(6)
  end
end
