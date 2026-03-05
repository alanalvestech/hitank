# Edit a message
# Usage: ruby scripts/edit_message.rb CHANNEL_ID MESSAGE_ID NEW_CONTENT

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID MESSAGE_ID NEW_CONTENT")
message_id = ARGV[1] or abort("Missing MESSAGE_ID")
content    = ARGV[2] or abort("Missing NEW_CONTENT")

data = discord_request(:patch, "/channels/#{channel_id}/messages/#{message_id}", body: { 'content' => content })

puts "Message edited: #{data['id']}"
