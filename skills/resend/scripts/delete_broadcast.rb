# Delete a broadcast
# Usage: ruby scripts/delete_broadcast.rb BROADCAST_ID

require_relative 'auth'

broadcast_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BROADCAST_ID")

resend_request(:delete, "/broadcasts/#{broadcast_id}")

puts "Deleted broadcast: #{broadcast_id}"
