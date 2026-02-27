class ChangeListingStatusToInteger < ActiveRecord::Migration[7.0]
  def up
    # Since we have existing string data, we'll clear it and change type
    remove_column :listings, :status
    add_column :listings, :status, :integer, default: 0
  end

  def down
    remove_column :listings, :status
    add_column :listings, :status, :string, default: "available"
  end
end
