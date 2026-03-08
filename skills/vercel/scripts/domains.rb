# List all Vercel domains
# Usage: ruby scripts/domains.rb

require_relative 'auth'

data = vercel_request(:get, '/v5/domains')

(data['domains'] || []).each do |d|
  configured = d['verified'] ? 'verified' : 'pending'
  created    = d['createdAt'] ? Time.at(d['createdAt'] / 1000).utc.strftime('%Y-%m-%dT%H:%M:%SZ') : '-'
  puts "#{d['name']}\t#{configured}\t#{created}"
end
