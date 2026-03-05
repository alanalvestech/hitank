# List add-ons for a Heroku app
# Usage: ruby scripts/addons.rb APP

require_relative 'auth'

app = ARGV[0] or abort("Usage: ruby #{__FILE__} APP")

data = heroku_request(:get, "/apps/#{app}/addons")

data.each do |a|
  name  = a['name'] || '-'
  plan  = a.dig('plan', 'name') || '-'
  state = a['state'] || '-'
  puts "#{name}\t#{plan}\t#{state}"
end
