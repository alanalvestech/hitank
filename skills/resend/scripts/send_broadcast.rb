# Send a broadcast
# Usage: ruby scripts/send_broadcast.rb BROADCAST_ID [--scheduled-at DATETIME]
# Example: ruby scripts/send_broadcast.rb bc_123
# Example: ruby scripts/send_broadcast.rb bc_123 --scheduled-at "2026-03-10T10:00:00Z"

require_relative 'auth'

broadcast_id = ARGV[0] or abort("Usage: ruby #{__FILE__} BROADCAST_ID [--scheduled-at DATETIME]")

body = {}
if (idx = ARGV.index('--scheduled-at')) && ARGV[idx + 1]
  body['scheduled_at'] = ARGV[idx + 1]
end

data = resend_request(:post, "/broadcasts/#{broadcast_id}/send", body: body)

puts "Broadcast sent: #{broadcast_id}"
