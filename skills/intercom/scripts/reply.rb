# Reply to an Intercom conversation
# Usage: ruby scripts/reply.rb CONVERSATION_ID --admin_id ADMIN_ID --body "Reply text"

require_relative 'auth'

conv_id  = ARGV[0] or abort("Usage: ruby #{__FILE__} CONVERSATION_ID --admin_id ADMIN_ID --body \"Reply text\"")
admin_id = nil
body     = nil

i = 1
while i < ARGV.length
  case ARGV[i]
  when '--admin_id'
    admin_id = ARGV[i + 1]
    i += 2
  when '--body'
    body = ARGV[i + 1]
    i += 2
  else
    i += 1
  end
end

abort("Missing --admin_id") unless admin_id
abort("Missing --body")     unless body

payload = {
  message_type: 'comment',
  type:         'admin',
  admin_id:     admin_id,
  body:         body
}

data = intercom_request(:post, "/conversations/#{conv_id}/reply", body: payload)

puts "Reply sent to conversation #{conv_id}"
puts "id:\t#{data['id']}" if data && data['id']
