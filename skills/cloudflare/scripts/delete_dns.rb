# Delete a DNS record from a Cloudflare zone
# Usage: ruby scripts/delete_dns.rb ZONE_ID RECORD_ID

require_relative 'auth'

if ARGV.length < 2
  abort "Usage: ruby #{__FILE__} ZONE_ID RECORD_ID"
end

zone_id   = ARGV[0]
record_id = ARGV[1]

data = cf_request(:delete, "/zones/#{zone_id}/dns_records/#{record_id}")

unless data['success']
  abort "Error: #{(data['errors'] || []).map { |e| e['message'] }.join(', ')}"
end

puts "Deleted DNS record #{record_id}"
