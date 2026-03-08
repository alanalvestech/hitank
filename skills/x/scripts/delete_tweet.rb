# Delete a tweet by ID
# Usage: ruby scripts/delete_tweet.rb TWEET_ID

require_relative 'auth'

tweet_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TWEET_ID")

data = x_request(:delete, "/2/tweets/#{tweet_id}")

if data && data.dig('data', 'deleted')
  puts "Tweet #{tweet_id} deleted successfully."
else
  puts "Failed to delete tweet #{tweet_id}."
end
