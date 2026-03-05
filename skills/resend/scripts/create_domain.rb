# Create a domain
# Usage: ruby scripts/create_domain.rb DOMAIN_NAME [--region REGION]
# Regions: us-east-1 (default), eu-west-1, sa-east-1, ap-northeast-1

require_relative 'auth'

domain_name = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN_NAME [--region REGION]")

body = { 'name' => domain_name }

if (idx = ARGV.index('--region')) && ARGV[idx + 1]
  body['region'] = ARGV[idx + 1]
end

data = resend_request(:post, '/domains', body: body)

puts "id:\t#{data['id'] || '-'}"
puts "name:\t#{data['name'] || domain_name}"
puts "status:\t#{data['status'] || '-'}"

if data['records']
  puts "\nAdd these DNS records:"
  data['records'].each do |r|
    puts "  #{r['record_type'] || r['type']}\t#{r['name'] || '-'}\t#{r['value'] || '-'}"
  end
end
