# Get details for a Heroku app
# Usage: ruby scripts/app.rb APP_NAME_OR_ID

require_relative 'auth'

app_name = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_NAME_OR_ID")

data = heroku_request(:get, "/apps/#{app_name}")

region  = data.dig('region', 'name') || '-'
stack   = data.dig('stack', 'name') || data['stack'] || '-'
web_url = data['web_url'] || '-'
git_url = data['git_url'] || '-'
created = data['created_at'] || '-'

puts "name:\t#{data['name']}"
puts "region:\t#{region}"
puts "stack:\t#{stack}"
puts "web_url:\t#{web_url}"
puts "git_url:\t#{git_url}"
puts "created_at:\t#{created}"
