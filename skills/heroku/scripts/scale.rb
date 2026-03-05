# Scale a process type for a Heroku app
# Usage: ruby scripts/scale.rb APP TYPE QUANTITY [SIZE]

require_relative 'auth'

app      = ARGV[0] or abort("Usage: ruby #{__FILE__} APP TYPE QUANTITY [SIZE]")
type     = ARGV[1] or abort("Missing TYPE")
quantity = ARGV[2] or abort("Missing QUANTITY")
size     = ARGV[3]

body = { quantity: quantity.to_i }
body[:size] = size if size

data = heroku_request(:patch, "/apps/#{app}/formation/#{type}", body: body)

puts "Scaled #{type} to #{data['quantity']}x #{data['size']} for #{app}"
