class AddRatingPendingColumnToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :rating_pending, :boolean, default: false, null: false
  end
end
