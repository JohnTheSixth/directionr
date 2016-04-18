class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    User.all.each do |user|
    	user.update_attributes(username: user.email)
  	end
  end
end
