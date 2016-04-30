class Direction < ActiveRecord::Base

	belongs_to :user

	# Used only when a Direction is initially created
	def add_stats_on_creation
		self['published_at'] = Time.zone.now
		self['short_url'] = SecureRandom.urlsafe_base64

		if Direction.find_by_short_url(self.short_url) != nil
			self.errors.add(:url_error, 'Sorry, there was an error creating the unique URL for your directions. Please save your directions again.')
			return false
		else
			return true
		end
	end	

end