# Enable or disable domain lock
# Usage: ruby scripts/domain_lock.rb DOMAIN --enable|--disable

require_relative 'auth'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN --enable|--disable")

if ARGV.include?('--enable')
  hostinger_request(:put, "/api/domains/v1/portfolio/#{domain}/domain-lock")
  puts "Domain lock enabled for #{domain}"
elsif ARGV.include?('--disable')
  hostinger_request(:delete, "/api/domains/v1/portfolio/#{domain}/domain-lock")
  puts "Domain lock disabled for #{domain}"
else
  abort("Specify --enable or --disable")
end
