# List DNS snapshots for a domain
# Usage: ruby scripts/dns_snapshots.rb DOMAIN

require_relative 'auth'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN")

data = hostinger_request(:get, "/api/dns/v1/snapshots/#{domain}")

(data || []).each do |s|
  puts "#{s['id']}\t#{s['created_at'] || '-'}\t#{s['reason'] || '-'}"
end
