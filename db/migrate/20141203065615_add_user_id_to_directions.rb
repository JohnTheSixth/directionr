class AddUserIdToDirections < ActiveRecord::Migration
  def change
    add_column :directions, :user_id, :integer
  end
end
