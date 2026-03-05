# List members in a guild
# Usage: ruby scripts/members.rb GUILD_ID [--limit N]

require_relative 'auth'

guild_id = ARGV[0] or abort("Usage: ruby #{__FILE__} GUILD_ID [--limit N]")

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
else
  params['limit'] = '50'
end

data = discord_request(:get, "/guilds/#{guild_id}/members", params: params)

data.each do |m|
  user = m['user'] || {}
  nick = m['nick'] || user['username'] || 'unknown'
  username = user['username'] || '-'
  puts "#{user['id']}\t#{username}\t#{nick}"
end
