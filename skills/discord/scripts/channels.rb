# List channels in a guild
# Usage: ruby scripts/channels.rb GUILD_ID [--type TYPE]
# Types: 0=text, 2=voice, 4=category, 5=announcement, 13=stage, 15=forum

require_relative 'auth'

guild_id = ARGV[0] or abort("Usage: ruby #{__FILE__} GUILD_ID [--type TYPE]")

type_filter = nil
if (idx = ARGV.index('--type')) && ARGV[idx + 1]
  type_filter = ARGV[idx + 1].to_i
end

data = discord_request(:get, "/guilds/#{guild_id}/channels")

type_names = { 0 => 'text', 2 => 'voice', 4 => 'category', 5 => 'announcement', 13 => 'stage', 15 => 'forum' }

data.each do |c|
  next if type_filter && c['type'] != type_filter
  type_name = type_names[c['type']] || c['type'].to_s
  puts "#{c['id']}\t#{type_name}\t#{c['name']}"
end
