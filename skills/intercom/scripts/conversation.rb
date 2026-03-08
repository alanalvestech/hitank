# Get Intercom conversation details
# Usage: ruby scripts/conversation.rb CONVERSATION_ID

require_relative 'auth'

conv_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CONVERSATION_ID")

data = intercom_request(:get, "/conversations/#{conv_id}")

state   = data['state'] || '-'
subject = data.dig('source', 'subject') || '-'
created = data['created_at'] ? Time.at(data['created_at']).strftime('%Y-%m-%d %H:%M') : '-'

puts "id:\t#{data['id']}"
puts "state:\t#{state}"
puts "subject:\t#{subject}"
puts "created_at:\t#{created}"

# Source message
source_author = data.dig('source', 'author', 'name') || data.dig('source', 'author', 'email') || '-'
source_body   = data.dig('source', 'body') || ''
puts "\n--- Source ---"
puts "from:\t#{source_author}"
puts source_body.gsub(/<[^>]+>/, ' ').gsub(/\s+/, ' ').strip

# Conversation parts (replies)
parts = data.dig('conversation_parts', 'conversation_parts') || []
parts.each do |part|
  author = part.dig('author', 'name') || part.dig('author', 'email') || '-'
  type   = part['part_type'] || '-'
  body   = part['body'] || ''
  time   = part['created_at'] ? Time.at(part['created_at']).strftime('%Y-%m-%d %H:%M') : '-'
  puts "\n--- #{type} (#{time}) ---"
  puts "from:\t#{author}"
  puts body.gsub(/<[^>]+>/, ' ').gsub(/\s+/, ' ').strip
end
