class UpdateUsernameOfUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
    	user.update_attributes(username: user.email.gsub(/\@/, '_').gsub(/\.com/, ''))
  	end
  end
end
