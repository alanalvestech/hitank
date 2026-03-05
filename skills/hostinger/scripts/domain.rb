# Get domain details
# Usage: ruby scripts/domain.rb DOMAIN

require_relative 'auth'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN")

data = hostinger_request(:get, "/api/domains/v1/portfolio/#{domain}")

puts "domain:\t#{data['domain'] || '-'}"
puts "status:\t#{data['status'] || '-'}"
puts "expires_at:\t#{data['expires_at'] || '-'}"
puts "auto_renew:\t#{data['auto_renew'] || '-'}"
puts "domain_lock:\t#{data['domain_lock'] || '-'}"
puts "privacy:\t#{data['privacy_protection'] || '-'}"
puts "nameservers:\t#{(data['nameservers'] || []).join(', ')}"
