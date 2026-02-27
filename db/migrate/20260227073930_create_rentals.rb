class CreateRentals < ActiveRecord::Migration[7.0]
  def change
    create_table :rentals do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :renter, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :status, default: "pending"
      t.references :owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
