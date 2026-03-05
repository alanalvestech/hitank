# List DNS records for a domain
# Usage: ruby scripts/dns_records.rb DOMAIN

require_relative 'auth'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN")

data = hostinger_request(:get, "/api/dns/v1/zones/#{domain}")

(data || []).each do |r|
  type = r['type'] || '-'
  name = r['name'] || '-'
  val  = r['content'] || r['value'] || '-'
  ttl  = r['ttl'] || '-'
  puts "#{type}\t#{name}\t#{val}\t#{ttl}"
end
