class User < ActiveRecord::Base

	has_secure_password

	has_many :directions

	validates_presence_of :first_name, :last_name, :email, :password_confirmation, :username, :on => :create
	validates_presence_of :email, :on => :send_password_reset

	before_create { generate_token(:auth_token) }

	def to_param
		"#{id}-#{username}"
	end

	def send_account_create
	end

	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
	end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end

end