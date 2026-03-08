# List DNS records for a Cloudflare zone
# Usage: ruby scripts/dns_records.rb ZONE_ID

require_relative 'auth'

zone_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ZONE_ID")

data = cf_request(:get, "/zones/#{zone_id}/dns_records?per_page=100")

unless data['success']
  abort "Error: #{(data['errors'] || []).map { |e| e['message'] }.join(', ')}"
end

data['result'].each do |rec|
  proxied = rec['proxied'] ? 'proxied' : 'dns_only'
  ttl     = rec['ttl'] == 1 ? 'auto' : rec['ttl'].to_s
  puts "#{rec['id']}\t#{rec['type']}\t#{rec['name']}\t#{rec['content']}\t#{ttl}\t#{proxied}"
end
