# List Zendesk knowledge base articles
# Usage: ruby scripts/articles.rb

require_relative 'auth'

data = zendesk_request(:get, '/help_center/articles')
articles = data['articles'] || []

if articles.empty?
  puts "No articles found."
  exit 0
end

articles.each do |a|
  puts "##{a['id']}\t#{a['draft'] ? 'draft' : 'published'}\t#{a['title']}\t#{a['updated_at']}"
end
