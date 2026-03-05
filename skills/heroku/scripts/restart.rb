# Restart all dynos for a Heroku app
# Usage: ruby scripts/restart.rb APP

require_relative 'auth'

app = ARGV[0] or abort("Usage: ruby #{__FILE__} APP")

heroku_request(:delete, "/apps/#{app}/dynos")

puts "All dynos restarted for #{app}"
