class AddApprovalStatusToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :approval_status, :string, default: "pending", null: false
    add_index :listings, :approval_status
  end
end
