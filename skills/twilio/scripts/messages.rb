# List Twilio messages
# Usage: ruby scripts/messages.rb [--to NUMBER] [--from NUMBER]

require_relative 'auth'

to_number   = nil
from_number = nil

i = 0
while i < ARGV.length
  case ARGV[i]
  when '--to'
    to_number = ARGV[i + 1]
    i += 2
  when '--from'
    from_number = ARGV[i + 1]
    i += 2
  else
    i += 1
  end
end

path = "/Accounts/#{ACCOUNT_SID}/Messages.json"
params = []
params << "To=#{URI.encode_www_form_component(to_number)}" if to_number
params << "From=#{URI.encode_www_form_component(from_number)}" if from_number
path += "?#{params.join('&')}" unless params.empty?

data = twilio_request(:get, path)

messages = data['messages'] || []

if messages.empty?
  puts "No messages found"
  exit 0
end

messages.each do |msg|
  sid       = msg['sid'] || '-'
  from      = msg['from'] || '-'
  to        = msg['to'] || '-'
  status    = msg['status'] || '-'
  direction = msg['direction'] || '-'
  date_sent = msg['date_sent'] || '-'
  body      = (msg['body'] || '-')[0..80]
  puts "#{sid}\t#{from}\t#{to}\t#{status}\t#{direction}\t#{date_sent}\t#{body}"
end
