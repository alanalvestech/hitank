# List sent emails
# Usage: ruby scripts/emails.rb

require_relative 'auth'

data = resend_request(:get, '/emails')

(data['data'] || []).each do |e|
  to = (e['to'] || []).join(', ')
  puts "#{e['id']}\t#{e['subject'] || '-'}\t#{to}\t#{e['last_event'] || '-'}\t#{e['created_at'] || '-'}"
end
