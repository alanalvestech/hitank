# Delete DNS records for a domain
# Usage: ruby scripts/dns_delete.rb DOMAIN JSON_RECORDS
# Example: ruby scripts/dns_delete.rb example.com '[{"type":"A","name":"@","content":"1.2.3.4"}]'

require_relative 'auth'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN JSON_RECORDS")
json   = ARGV[1] or abort("Missing JSON_RECORDS")

records = JSON.parse(json)
hostinger_request(:delete, "/api/dns/v1/zones/#{domain}", body: { 'records' => records })

puts "DNS records deleted for #{domain}"
