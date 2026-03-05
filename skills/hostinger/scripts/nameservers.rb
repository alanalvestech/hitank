# Update domain nameservers
# Usage: ruby scripts/nameservers.rb DOMAIN NS1 NS2 [NS3 NS4]

require_relative 'auth'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN NS1 NS2 [NS3 NS4]")
ns = ARGV[1..] || []
abort("At least 2 nameservers required") if ns.length < 2

hostinger_request(:put, "/api/domains/v1/portfolio/#{domain}/nameservers", body: { 'nameservers' => ns })

puts "Nameservers updated for #{domain}: #{ns.join(', ')}"
