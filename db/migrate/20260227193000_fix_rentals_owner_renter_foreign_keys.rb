class FixRentalsOwnerRenterForeignKeys < ActiveRecord::Migration[7.0]
  def up
    execute "PRAGMA foreign_keys = OFF"

    create_table :rentals_new do |t|
      t.integer :listing_id, null: false
      t.integer :renter_id, null: false
      t.date :start_date
      t.date :end_date
      t.string :status, default: "pending"
      t.integer :owner_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    execute <<~SQL
      INSERT INTO rentals_new (listing_id, renter_id, start_date, end_date, status, owner_id, created_at, updated_at)
      SELECT listing_id, renter_id, start_date, end_date, status, owner_id, created_at, updated_at
      FROM rentals
    SQL

    drop_table :rentals
    rename_table :rentals_new, :rentals

    add_index :rentals, :listing_id
    add_index :rentals, :renter_id
    add_index :rentals, :owner_id

    add_foreign_key :rentals, :listings
    add_foreign_key :rentals, :users, column: :owner_id
    add_foreign_key :rentals, :users, column: :renter_id

    execute "PRAGMA foreign_keys = ON"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
