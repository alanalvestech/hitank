# Add a reaction to a message
# Usage: ruby scripts/react.rb CHANNEL_ID MESSAGE_ID EMOJI
# EMOJI can be a unicode emoji (e.g. ✅) or custom format name:id

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID MESSAGE_ID EMOJI")
message_id = ARGV[1] or abort("Missing MESSAGE_ID")
emoji      = ARGV[2] or abort("Missing EMOJI")

encoded_emoji = URI.encode_www_form_component(emoji)
discord_request(:put, "/channels/#{channel_id}/messages/#{message_id}/reactions/#{encoded_emoji}/@me")

puts "Reacted with #{emoji}"
