# List guilds (servers) the bot is in
# Usage: ruby scripts/guilds.rb

require_relative 'auth'

data = discord_request(:get, '/users/@me/guilds')

data.each do |g|
  owner = g['owner'] ? ' (owner)' : ''
  puts "#{g['id']}\t#{g['name']}#{owner}"
end
