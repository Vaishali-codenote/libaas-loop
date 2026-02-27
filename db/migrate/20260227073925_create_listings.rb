class CreateListings < ActiveRecord::Migration[7.0]
  def change
    create_table :listings do |t|
      t.string :title
      t.text :description
      t.string :category
      t.decimal :price_per_day
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
