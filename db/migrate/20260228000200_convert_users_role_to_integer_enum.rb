class ConvertUsersRoleToIntegerEnum < ActiveRecord::Migration[7.0]
  class MigrationUser < ApplicationRecord
    self.table_name = "users"
  end

  def up
    add_column :users, :role_tmp, :integer, default: 0, null: false

    MigrationUser.reset_column_information
    MigrationUser.find_each do |user|
      role_value = user.read_attribute(:role).to_s
      mapped = role_value == "admin" ? 1 : 0
      user.update_columns(role_tmp: mapped)
    end

    remove_column :users, :role
    rename_column :users, :role_tmp, :role
  end

  def down
    add_column :users, :role_tmp, :string, default: "user", null: false

    MigrationUser.reset_column_information
    MigrationUser.find_each do |user|
      role_value = user.read_attribute(:role).to_i == 1 ? "admin" : "user"
      user.update_columns(role_tmp: role_value)
    end

    remove_column :users, :role
    rename_column :users, :role_tmp, :role
  end
end
