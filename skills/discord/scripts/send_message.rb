# Send a message to a channel
# Usage: ruby scripts/send_message.rb CHANNEL_ID MESSAGE

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID MESSAGE")
message    = ARGV[1] or abort("Missing MESSAGE")

data = discord_request(:post, "/channels/#{channel_id}/messages", body: { 'content' => message })

puts "Message sent: #{data['id']}"
