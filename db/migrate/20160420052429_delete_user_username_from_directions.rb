class DeleteUserUsernameFromDirections < ActiveRecord::Migration
  def change
  	remove_column :directions, :user_username, :string
  end
end
