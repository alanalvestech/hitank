# List all DigitalOcean domains
# Usage: ruby scripts/domains.rb

require_relative 'auth'

data = do_request(:get, '/domains')

data['domains'].each do |d|
  name = d['name'] || '-'
  ttl  = d['ttl'] || '-'
  puts "#{name}\t#{ttl}"
end
