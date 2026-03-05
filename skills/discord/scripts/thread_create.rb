# Create a thread from a message
# Usage: ruby scripts/thread_create.rb CHANNEL_ID MESSAGE_ID THREAD_NAME

require_relative 'auth'

channel_id  = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID MESSAGE_ID THREAD_NAME")
message_id  = ARGV[1] or abort("Missing MESSAGE_ID")
thread_name = ARGV[2] or abort("Missing THREAD_NAME")

data = discord_request(:post, "/channels/#{channel_id}/messages/#{message_id}/threads", body: { 'name' => thread_name })

puts "Thread created: #{data['id']} — #{data['name']}"
