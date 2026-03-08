# List Intercom conversations
# Usage: ruby scripts/conversations.rb

require_relative 'auth'

data = intercom_request(:get, '/conversations')

conversations = data['conversations'] || []
conversations.each do |conv|
  state   = conv['state'] || '-'
  subject = conv.dig('source', 'subject') || conv.dig('source', 'body') || '-'
  subject = subject[0..80] if subject.length > 80
  created = conv['created_at'] ? Time.at(conv['created_at']).strftime('%Y-%m-%d %H:%M') : '-'
  puts "#{conv['id']}\t#{state}\t#{created}\t#{subject}"
end
