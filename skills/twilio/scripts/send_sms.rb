# Send an SMS via Twilio
# Usage: ruby scripts/send_sms.rb --from '+15551234567' --to '+15559876543' --body 'Hello!'

require_relative 'auth'

from_number = nil
to_number   = nil
body        = nil

i = 0
while i < ARGV.length
  case ARGV[i]
  when '--from'
    from_number = ARGV[i + 1]
    i += 2
  when '--to'
    to_number = ARGV[i + 1]
    i += 2
  when '--body'
    body = ARGV[i + 1]
    i += 2
  else
    i += 1
  end
end

abort("Missing --from") unless from_number
abort("Missing --to") unless to_number
abort("Missing --body") unless body

data = twilio_request(:post, "/Accounts/#{ACCOUNT_SID}/Messages.json", form_data: {
  'From' => from_number,
  'To'   => to_number,
  'Body' => body
})

puts "sid:\t#{data['sid']}"
puts "from:\t#{data['from']}"
puts "to:\t#{data['to']}"
puts "status:\t#{data['status']}"
puts "body:\t#{data['body']}"
