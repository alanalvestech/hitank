# Delete a domain
# Usage: ruby scripts/delete_domain.rb DOMAIN_ID

require_relative 'auth'

domain_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN_ID")

resend_request(:delete, "/domains/#{domain_id}")

puts "Deleted domain: #{domain_id}"
