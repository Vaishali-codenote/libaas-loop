class AddImageNameToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :image_name, :string, default: "sample1.jpg", null: false
  end
end
