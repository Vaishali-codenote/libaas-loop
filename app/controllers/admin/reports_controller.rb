class Admin::ReportsController < Admin::BaseController
  def index
    completed_or_active = Rental.where(status: %w[active completed]).includes(:listing)

    @total_platform_revenue = completed_or_active.sum { |rental| rental.total_price.to_f }
    @most_rented_category = Rental.joins(:listing).group("listings.category").order(Arel.sql("COUNT(rentals.id) DESC")).count.first

    @top_earning_users = User.includes(:rentals_as_owner).map { |user| [user, user.total_earnings] }
      .sort_by { |_user, earnings| -earnings }
      .first(5)

    @active_rentals_by_status = Rental.group(:status).count.slice("pending", "approved", "active", "completed", "cancelled", "rejected")

    @monthly_revenue = Hash.new(0)
    completed_or_active.each do |rental|
      key = rental.created_at.strftime("%Y-%m")
      @monthly_revenue[key] += rental.total_price.to_f
    end
    @monthly_revenue = @monthly_revenue.sort.to_h
  end
end
