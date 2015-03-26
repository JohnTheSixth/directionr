class User < ActiveRecord::Base

	has_secure_password

	has_many :directions

	validates_presence_of :first_name, :last_name, :email, :password_confirmation

	before_create { generate_token(:auth_token) }

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end

end