class User < ActiveRecord::Base

	has_many :directions, dependent: :destroy

	has_secure_password

	validates_presence_of :first_name, :last_name, :email, :password_confirmation, :username, :on => :create
	validates_presence_of :first_name, :last_name, :email, :password, :username, :on => :update_account
	validates_presence_of :email, :on => :send_password_reset

	before_create { generate_token(:auth_token) }

	# def to_param
	# 	username
	# end

	def check_existing
		self.errors.add(:bad_input, 'That email is already taken.') if User.find_by_email(self.email)
		self.errors.add(:bad_input, 'That username is already taken.') if User.find_by_username(self.username)
		
		if self.errors.get(:bad_input) != nil
			return false
		else
			return true
		end
	end

	def send_account_create
		generate_token(:account_create_token)
		self.account_create_sent_at = Time.zone.now
		save!
		UserMailer.account_create(self).deliver
	end

	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
	end

	def update_account(update_user_params)
		update_user_params.each do |key, value|
			if self[key] != value
				self[key] = value
			end
			save!
		end
	end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end

end