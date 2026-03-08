# Purge all cache for a Cloudflare zone
# Usage: ruby scripts/purge_cache.rb ZONE_ID

require_relative 'auth'

zone_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ZONE_ID")

data = cf_request(:post, "/zones/#{zone_id}/purge_cache", body: { purge_everything: true })

unless data['success']
  abort "Error: #{(data['errors'] || []).map { |e| e['message'] }.join(', ')}"
end

puts "Cache purged for zone #{zone_id}"
