# List Twilio incoming phone numbers
# Usage: ruby scripts/numbers.rb

require_relative 'auth'

data = twilio_request(:get, "/Accounts/#{ACCOUNT_SID}/IncomingPhoneNumbers.json")

numbers = data['incoming_phone_numbers'] || []

if numbers.empty?
  puts "No phone numbers found"
  exit 0
end

numbers.each do |num|
  sid           = num['sid'] || '-'
  phone_number  = num['phone_number'] || '-'
  friendly_name = num['friendly_name'] || '-'
  capabilities  = num['capabilities'] || {}
  sms           = capabilities['sms'] ? 'sms' : '-'
  voice         = capabilities['voice'] ? 'voice' : '-'
  mms           = capabilities['mms'] ? 'mms' : '-'
  puts "#{sid}\t#{phone_number}\t#{friendly_name}\t#{voice}\t#{sms}\t#{mms}"
end
