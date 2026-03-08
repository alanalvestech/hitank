# Get Twilio message details
# Usage: ruby scripts/message.rb MESSAGE_SID

require_relative 'auth'

message_sid = ARGV[0] or abort("Usage: ruby #{__FILE__} MESSAGE_SID")

data = twilio_request(:get, "/Accounts/#{ACCOUNT_SID}/Messages/#{message_sid}.json")

puts "sid:\t#{data['sid']}"
puts "from:\t#{data['from']}"
puts "to:\t#{data['to']}"
puts "body:\t#{data['body']}"
puts "status:\t#{data['status']}"
puts "direction:\t#{data['direction']}"
puts "date_sent:\t#{data['date_sent']}"
puts "date_created:\t#{data['date_created']}"
puts "price:\t#{data['price']}"
puts "price_unit:\t#{data['price_unit']}"
puts "num_segments:\t#{data['num_segments']}"
puts "error_code:\t#{data['error_code']}"
puts "error_message:\t#{data['error_message']}"
