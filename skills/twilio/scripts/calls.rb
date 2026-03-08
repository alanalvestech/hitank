# List Twilio calls
# Usage: ruby scripts/calls.rb

require_relative 'auth'

data = twilio_request(:get, "/Accounts/#{ACCOUNT_SID}/Calls.json")

calls = data['calls'] || []

if calls.empty?
  puts "No calls found"
  exit 0
end

calls.each do |call|
  sid       = call['sid'] || '-'
  from      = call['from'] || '-'
  to        = call['to'] || '-'
  status    = call['status'] || '-'
  direction = call['direction'] || '-'
  duration  = call['duration'] || '-'
  start_time = call['start_time'] || '-'
  puts "#{sid}\t#{from}\t#{to}\t#{status}\t#{direction}\t#{duration}s\t#{start_time}"
end
