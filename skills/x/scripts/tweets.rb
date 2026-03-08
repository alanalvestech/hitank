# List recent tweets for a user
# Usage: ruby scripts/tweets.rb [--user_id ID]

require_relative 'auth'

user_id = nil

i = 0
while i < ARGV.length
  if ARGV[i] == '--user_id' && ARGV[i + 1]
    user_id = ARGV[i + 1]
    i += 2
  else
    i += 1
  end
end

# If no user_id provided, fetch the authenticated user's ID
if user_id.nil?
  me = x_request(:get, '/2/users/me')
  user_id = me.dig('data', 'id')
end

data = x_request(:get, "/2/users/#{user_id}/tweets", params: {
  'max_results'  => '10',
  'tweet.fields' => 'created_at,public_metrics'
})

tweets = data['data'] || []

if tweets.empty?
  puts "No tweets found."
  exit 0
end

tweets.each do |tweet|
  metrics = tweet['public_metrics'] || {}
  created = tweet['created_at'] || '-'
  likes   = metrics['like_count'] || 0
  rts     = metrics['retweet_count'] || 0
  replies = metrics['reply_count'] || 0

  puts "---"
  puts "ID:       #{tweet['id']}"
  puts "Date:     #{created}"
  puts "Text:     #{tweet['text']}"
  puts "Likes:    #{likes}  Retweets: #{rts}  Replies: #{replies}"
end
