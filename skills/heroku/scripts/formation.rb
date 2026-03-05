# List formation (process types/scaling) for a Heroku app
# Usage: ruby scripts/formation.rb APP

require_relative 'auth'

app = ARGV[0] or abort("Usage: ruby #{__FILE__} APP")

data = heroku_request(:get, "/apps/#{app}/formation")

data.each do |f|
  type     = f['type'] || '-'
  quantity = f['quantity'] || '-'
  size     = f['size'] || '-'
  puts "#{type}\t#{quantity}\t#{size}"
end
