# List all domains in portfolio
# Usage: ruby scripts/domains.rb

require_relative 'auth'

data = hostinger_request(:get, '/api/domains/v1/portfolio')

(data || []).each do |d|
  status  = d['status'] || '-'
  expires = d['expires_at'] || '-'
  puts "#{d['domain']}\t#{status}\t#{expires}"
end
