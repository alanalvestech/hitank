# Get DigitalOcean account info
# Usage: ruby scripts/account.rb

require_relative 'auth'

data = do_request(:get, '/account')
account = data['account']

puts "email:\t#{account['email']}"
puts "uuid:\t#{account['uuid']}"
puts "droplet_limit:\t#{account['droplet_limit']}"
puts "floating_ip_limit:\t#{account['floating_ip_limit']}"
puts "status:\t#{account['status']}"
puts "status_message:\t#{account['status_message'] || '-'}"
