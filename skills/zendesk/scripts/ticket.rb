# Get details for a Zendesk ticket
# Usage: ruby scripts/ticket.rb TICKET_ID

require_relative 'auth'

ticket_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TICKET_ID")

data = zendesk_request(:get, "/tickets/#{ticket_id}")
t = data['ticket']

puts "id:\t#{t['id']}"
puts "subject:\t#{t['subject']}"
puts "status:\t#{t['status']}"
puts "priority:\t#{t['priority'] || '-'}"
puts "type:\t#{t['type'] || '-'}"
puts "requester_id:\t#{t['requester_id']}"
puts "assignee_id:\t#{t['assignee_id'] || '-'}"
puts "organization_id:\t#{t['organization_id'] || '-'}"
puts "tags:\t#{(t['tags'] || []).join(', ')}"
puts "created_at:\t#{t['created_at']}"
puts "updated_at:\t#{t['updated_at']}"
puts "description:\t#{t['description']}"
