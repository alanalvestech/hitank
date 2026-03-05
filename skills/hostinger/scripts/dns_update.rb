# Update DNS records for a domain
# Usage: ruby scripts/dns_update.rb DOMAIN JSON_RECORDS
# Example: ruby scripts/dns_update.rb example.com '[{"type":"A","name":"@","content":"1.2.3.4","ttl":3600}]'

require_relative 'auth'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN JSON_RECORDS")
json   = ARGV[1] or abort("Missing JSON_RECORDS")

records = JSON.parse(json)
hostinger_request(:put, "/api/dns/v1/zones/#{domain}", body: { 'records' => records })

puts "DNS records updated for #{domain}"
