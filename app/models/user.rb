class User < ApplicationRecord
	#callback to downcase email before saving to user.email
	before_save { self.email = email.downcase }
	
	#validate name input
	validates(
		:name, 
		presence: true, 
		length: { maximum: 50 })
	
	#validate email input
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates(
		:email, 
		presence: true, 
		length: { maximum: 255 },
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }
		)
end