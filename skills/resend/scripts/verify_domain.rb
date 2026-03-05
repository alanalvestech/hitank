# Verify a domain
# Usage: ruby scripts/verify_domain.rb DOMAIN_ID

require_relative 'auth'

domain_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN_ID")

data = resend_request(:post, "/domains/#{domain_id}/verify")

puts "Verification initiated for domain: #{domain_id}"
