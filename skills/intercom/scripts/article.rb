# Get Intercom article details
# Usage: ruby scripts/article.rb ARTICLE_ID

require_relative 'auth'

article_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ARTICLE_ID")

data = intercom_request(:get, "/articles/#{article_id}")

title       = data['title'] || '-'
state       = data['state'] || '-'
author_id   = data['author_id'] || '-'
created     = data['created_at'] ? Time.at(data['created_at']).strftime('%Y-%m-%d %H:%M') : '-'
updated     = data['updated_at'] ? Time.at(data['updated_at']).strftime('%Y-%m-%d %H:%M') : '-'
url         = data['url'] || '-'
description = data['description'] || '-'
body        = data['body'] || ''

puts "id:\t#{data['id']}"
puts "title:\t#{title}"
puts "state:\t#{state}"
puts "author_id:\t#{author_id}"
puts "url:\t#{url}"
puts "created_at:\t#{created}"
puts "updated_at:\t#{updated}"
puts "description:\t#{description}"
puts "\n--- Body ---"
puts body.gsub(/<[^>]+>/, ' ').gsub(/\s+/, ' ').strip
