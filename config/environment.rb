# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Time::DATE_FORMATS[:time] = "%B %d, %I:%M %p"
Time::DATE_FORMATS[:med] = "%b %e, %Y"
Time::DATE_FORMATS[:long] = "%B %e, %Y"
