# List Intercom help center articles
# Usage: ruby scripts/articles.rb

require_relative 'auth'

data = intercom_request(:get, '/articles')

articles = data['data'] || []
articles.each do |article|
  title   = article['title'] || '-'
  state   = article['state'] || '-'
  created = article['created_at'] ? Time.at(article['created_at']).strftime('%Y-%m-%d %H:%M') : '-'
  puts "#{article['id']}\t#{state}\t#{created}\t#{title}"
end
