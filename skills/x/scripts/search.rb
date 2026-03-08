# Search recent tweets
# Usage: ruby scripts/search.rb 'search query'

require_relative 'auth'

query = ARGV[0] or abort("Usage: ruby #{__FILE__} 'SEARCH_QUERY'")

data = x_request(:get, '/2/tweets/search/recent', params: {
  'query'        => query,
  'max_results'  => '10',
  'tweet.fields' => 'created_at,public_metrics,author_id'
})

tweets = data['data'] || []

if tweets.empty?
  puts "No tweets found for query: #{query}"
  exit 0
end

tweets.each do |tweet|
  metrics = tweet['public_metrics'] || {}
  created = tweet['created_at'] || '-'
  likes   = metrics['like_count'] || 0
  rts     = metrics['retweet_count'] || 0

  puts "---"
  puts "ID:        #{tweet['id']}"
  puts "Author ID: #{tweet['author_id']}"
  puts "Date:      #{created}"
  puts "Text:      #{tweet['text']}"
  puts "Likes:     #{likes}  Retweets: #{rts}"
end
