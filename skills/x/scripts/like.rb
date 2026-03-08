# Like a tweet
# Usage: ruby scripts/like.rb TWEET_ID

require_relative 'auth'

tweet_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TWEET_ID")

# Get authenticated user's ID (required for the likes endpoint)
me = x_request(:get, '/2/users/me')
user_id = me.dig('data', 'id')

data = x_request(:post, "/2/users/#{user_id}/likes", body: { 'tweet_id' => tweet_id })

if data && data.dig('data', 'liked')
  puts "Tweet #{tweet_id} liked successfully."
else
  puts "Failed to like tweet #{tweet_id}."
end
