# List DNS records for a DigitalOcean domain
# Usage: ruby scripts/dns_records.rb DOMAIN_NAME

require_relative 'auth'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN_NAME")

data = do_request(:get, "/domains/#{domain}/records")

data['domain_records'].each do |r|
  id    = r['id']
  type  = r['type'] || '-'
  name  = r['name'] || '-'
  value = r['data'] || '-'
  ttl   = r['ttl'] || '-'
  puts "#{id}\t#{type}\t#{name}\t#{value}\t#{ttl}"
end
