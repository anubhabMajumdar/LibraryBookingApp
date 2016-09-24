class FixColumnNamePasswordDisgest < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :Password_digest, :password_digest
  end
end
