# List roles in a guild
# Usage: ruby scripts/roles.rb GUILD_ID

require_relative 'auth'

guild_id = ARGV[0] or abort("Usage: ruby #{__FILE__} GUILD_ID")

data = discord_request(:get, "/guilds/#{guild_id}/roles")

data.each do |r|
  puts "#{r['id']}\t#{r['name']}\tcolor:#{r['color']}\tposition:#{r['position']}"
end
