# Update a Zendesk ticket
# Usage: ruby scripts/update_ticket.rb TICKET_ID [--status STATUS] [--assignee USER_ID] [--comment TEXT]

require_relative 'auth'

ticket_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TICKET_ID [--status STATUS] [--assignee USER_ID] [--comment TEXT]")

ticket_update = {}
comment = nil

i = 1
while i < ARGV.length
  case ARGV[i]
  when '--status'
    ticket_update[:status] = ARGV[i + 1]
    i += 2
  when '--assignee'
    ticket_update[:assignee_id] = ARGV[i + 1].to_i
    i += 2
  when '--comment'
    comment = ARGV[i + 1]
    i += 2
  else
    i += 1
  end
end

if ticket_update.empty? && comment.nil?
  abort "Nothing to update. Provide --status, --assignee, or --comment."
end

ticket_update[:comment] = { body: comment, public: false } if comment

payload = { ticket: ticket_update }
data = zendesk_request(:put, "/tickets/#{ticket_id}", body: payload)
t = data['ticket']

puts "Updated ticket ##{t['id']}: #{t['subject']}"
puts "status:\t#{t['status']}"
puts "assignee_id:\t#{t['assignee_id'] || '-'}"
puts "updated_at:\t#{t['updated_at']}"
