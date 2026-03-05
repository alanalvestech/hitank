# Pin a message
# Usage: ruby scripts/pin.rb CHANNEL_ID MESSAGE_ID

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID MESSAGE_ID")
message_id = ARGV[1] or abort("Missing MESSAGE_ID")

discord_request(:put, "/channels/#{channel_id}/pins/#{message_id}")

puts "Message pinned: #{message_id}"
