module WelcomeHelper
	def format_tumblr_date(date)
		Time.parse(date).strftime("- %b %d, %Y -").upcase
	end
end
