# Post a new tweet
# Usage: ruby scripts/post_tweet.rb 'Tweet text here'

require_relative 'auth'

text = ARGV[0] or abort("Usage: ruby #{__FILE__} 'TWEET_TEXT'")

data = x_request(:post, '/2/tweets', body: { 'text' => text })

tweet = data['data']
puts "Tweet posted successfully!"
puts "ID:   #{tweet['id']}"
puts "Text: #{tweet['text']}"
