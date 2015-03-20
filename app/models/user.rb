class User < ActiveRecord::Base

	has_secure_password

	has_many :directions

	validates_presence_of :first_name, :last_name, :email, :password_confirmation

end