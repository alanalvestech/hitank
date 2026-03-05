# Delete a message
# Usage: ruby scripts/delete_message.rb CHANNEL_ID MESSAGE_ID

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID MESSAGE_ID")
message_id = ARGV[1] or abort("Missing MESSAGE_ID")

discord_request(:delete, "/channels/#{channel_id}/messages/#{message_id}")

puts "Message deleted: #{message_id}"
