class AddUserUsernameToDirections < ActiveRecord::Migration
  def change
  	add_column :directions, :user_username, :string, :limit => 255
  end
end
