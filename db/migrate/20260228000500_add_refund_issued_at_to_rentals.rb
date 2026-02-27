class AddRefundIssuedAtToRentals < ActiveRecord::Migration[7.0]
  def change
    add_column :rentals, :refund_issued_at, :datetime
  end
end
