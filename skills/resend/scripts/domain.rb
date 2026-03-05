# Get domain details
# Usage: ruby scripts/domain.rb DOMAIN_ID

require_relative 'auth'

domain_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN_ID")

data = resend_request(:get, "/domains/#{domain_id}")

puts "id:\t#{data['id'] || '-'}"
puts "name:\t#{data['name'] || '-'}"
puts "status:\t#{data['status'] || '-'}"
puts "region:\t#{data['region'] || '-'}"
puts "created:\t#{data['created_at'] || '-'}"

if data['records']
  puts "\nDNS Records:"
  data['records'].each do |r|
    puts "  #{r['record_type'] || r['type']}\t#{r['name'] || '-'}\t#{r['status'] || '-'}"
  end
end
