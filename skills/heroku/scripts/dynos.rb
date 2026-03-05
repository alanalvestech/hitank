# List dynos for a Heroku app
# Usage: ruby scripts/dynos.rb APP

require_relative 'auth'

app = ARGV[0] or abort("Usage: ruby #{__FILE__} APP")

data = heroku_request(:get, "/apps/#{app}/dynos")

data.each do |d|
  size    = d['size'] || '-'
  state   = d['state'] || '-'
  updated = d['updated_at'] || '-'
  puts "#{d['name']}\t#{d['type']}\t#{size}\t#{state}\t#{updated}"
end
