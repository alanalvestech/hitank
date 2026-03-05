# Read messages from a channel
# Usage: ruby scripts/messages.rb CHANNEL_ID [--limit N]

require_relative 'auth'

channel_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CHANNEL_ID [--limit N]")

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
else
  params['limit'] = '20'
end

data = discord_request(:get, "/channels/#{channel_id}/messages", params: params)

data.reverse.each do |m|
  author = m.dig('author', 'username') || 'unknown'
  content = (m['content'] || '')[0..200]
  timestamp = m['timestamp'] || '-'
  puts "#{m['id']}\t#{author}\t#{timestamp}\t#{content}"
end
