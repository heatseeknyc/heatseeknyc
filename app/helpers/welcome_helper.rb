module WelcomeHelper
	def format_tumblr_date(timestamp)
		Time.at(timestamp).strftime("- %m %b -").upcase
	end
end
