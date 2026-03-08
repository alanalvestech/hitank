# Get details for a Cloudflare zone
# Usage: ruby scripts/zone.rb ZONE_ID

require_relative 'auth'

zone_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ZONE_ID")

data = cf_request(:get, "/zones/#{zone_id}")

unless data['success']
  abort "Error: #{(data['errors'] || []).map { |e| e['message'] }.join(', ')}"
end

z = data['result']

puts "id:\t#{z['id']}"
puts "name:\t#{z['name']}"
puts "status:\t#{z['status']}"
puts "plan:\t#{z.dig('plan', 'name') || '-'}"
puts "account_id:\t#{z.dig('account', 'id') || '-'}"
puts "account_name:\t#{z.dig('account', 'name') || '-'}"
puts "name_servers:\t#{(z['name_servers'] || []).join(', ')}"
puts "created_on:\t#{z['created_on'] || '-'}"
puts "modified_on:\t#{z['modified_on'] || '-'}"
