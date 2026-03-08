# Create a DNS record in a Cloudflare zone
# Usage: ruby scripts/create_dns.rb ZONE_ID TYPE NAME CONTENT [--proxied] [--ttl TTL]

require_relative 'auth'

if ARGV.length < 4
  abort "Usage: ruby #{__FILE__} ZONE_ID TYPE NAME CONTENT [--proxied] [--ttl TTL]"
end

zone_id = ARGV[0]
type    = ARGV[1].upcase
name    = ARGV[2]
content = ARGV[3]

proxied = ARGV.include?('--proxied')
ttl     = 1  # auto

ttl_idx = ARGV.index('--ttl')
ttl = ARGV[ttl_idx + 1].to_i if ttl_idx && ARGV[ttl_idx + 1]

body = {
  type:    type,
  name:    name,
  content: content,
  ttl:     ttl,
  proxied: proxied
}

data = cf_request(:post, "/zones/#{zone_id}/dns_records", body: body)

unless data['success']
  abort "Error: #{(data['errors'] || []).map { |e| e['message'] }.join(', ')}"
end

rec = data['result']
puts "created_id:\t#{rec['id']}"
puts "type:\t#{rec['type']}"
puts "name:\t#{rec['name']}"
puts "content:\t#{rec['content']}"
puts "proxied:\t#{rec['proxied']}"
puts "ttl:\t#{rec['ttl']}"
