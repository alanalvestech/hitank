# Create a Zendesk ticket
# Usage: ruby scripts/create_ticket.rb 'SUBJECT' 'BODY'

require_relative 'auth'

subject = ARGV[0] or abort("Usage: ruby #{__FILE__} SUBJECT BODY")
body    = ARGV[1] or abort("Usage: ruby #{__FILE__} SUBJECT BODY")

payload = {
  ticket: {
    subject: subject,
    comment: { body: body }
  }
}

data = zendesk_request(:post, '/tickets', body: payload)
t = data['ticket']

puts "Created ticket ##{t['id']}: #{t['subject']}"
puts "status:\t#{t['status']}"
puts "created_at:\t#{t['created_at']}"
