# Get authenticated user info
# Usage: ruby scripts/me.rb

require_relative 'auth'

data = x_request(:get, '/2/users/me', params: {
  'user.fields' => 'public_metrics,description,created_at'
})

user = data['data']
metrics = user['public_metrics'] || {}

puts "Username:    @#{user['username']}"
puts "Name:        #{user['name']}"
puts "ID:          #{user['id']}"
puts "Description: #{user['description']}" if user['description']
puts "Created:     #{user['created_at']}"
puts "Followers:   #{metrics['followers_count']}"
puts "Following:   #{metrics['following_count']}"
puts "Tweets:      #{metrics['tweet_count']}"
