# Check domain availability
# Usage: ruby scripts/domain_availability.rb DOMAIN [TLD1 TLD2 ...]
# Example: ruby scripts/domain_availability.rb mysite com net io

require_relative 'auth'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN [TLD1 TLD2 ...]")
tlds = ARGV[1..] || ['com']

body = { 'domain' => domain, 'tlds' => tlds }
data = hostinger_request(:post, '/api/domains/v1/availability', body: body)

(data || []).each do |d|
  status = d['available'] ? 'AVAILABLE' : 'TAKEN'
  price  = d['price'] ? "$#{d['price']}" : '-'
  puts "#{d['domain']}\t#{status}\t#{price}"
end
