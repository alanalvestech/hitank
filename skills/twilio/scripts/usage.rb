# Get Twilio usage records
# Usage: ruby scripts/usage.rb

require_relative 'auth'

data = twilio_request(:get, "/Accounts/#{ACCOUNT_SID}/Usage/Records.json")

records = data['usage_records'] || []

if records.empty?
  puts "No usage records found"
  exit 0
end

records.each do |rec|
  category   = rec['category'] || '-'
  usage      = rec['usage'] || '-'
  usage_unit = rec['usage_unit'] || '-'
  price      = rec['price'] || '-'
  price_unit = rec['price_unit'] || '-'
  start_date = rec['start_date'] || '-'
  end_date   = rec['end_date'] || '-'
  puts "#{category}\t#{usage}\t#{usage_unit}\t#{price}\t#{price_unit}\t#{start_date}\t#{end_date}"
end
