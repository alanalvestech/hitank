# Get Twilio account info
# Usage: ruby scripts/account.rb

require_relative 'auth'

data = twilio_request(:get, "/Accounts/#{ACCOUNT_SID}.json")

puts "sid:\t#{data['sid']}"
puts "friendly_name:\t#{data['friendly_name']}"
puts "status:\t#{data['status']}"
puts "type:\t#{data['type']}"
puts "date_created:\t#{data['date_created']}"
puts "date_updated:\t#{data['date_updated']}"
