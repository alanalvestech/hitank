# Get tweet details by ID
# Usage: ruby scripts/tweet.rb TWEET_ID

require_relative 'auth'

tweet_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TWEET_ID")

data = x_request(:get, "/2/tweets/#{tweet_id}", params: {
  'tweet.fields' => 'created_at,public_metrics,author_id'
})

tweet   = data['data']
metrics = tweet['public_metrics'] || {}

puts "ID:        #{tweet['id']}"
puts "Author ID: #{tweet['author_id']}"
puts "Date:      #{tweet['created_at']}"
puts "Text:      #{tweet['text']}"
puts "Likes:     #{metrics['like_count'] || 0}"
puts "Retweets:  #{metrics['retweet_count'] || 0}"
puts "Replies:   #{metrics['reply_count'] || 0}"
puts "Quotes:    #{metrics['quote_count'] || 0}"
