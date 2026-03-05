# Enable or disable WHOIS privacy protection
# Usage: ruby scripts/privacy.rb DOMAIN --enable|--disable

require_relative 'auth'

domain = ARGV[0] or abort("Usage: ruby #{__FILE__} DOMAIN --enable|--disable")

if ARGV.include?('--enable')
  hostinger_request(:put, "/api/domains/v1/portfolio/#{domain}/privacy-protection")
  puts "Privacy protection enabled for #{domain}"
elsif ARGV.include?('--disable')
  hostinger_request(:delete, "/api/domains/v1/portfolio/#{domain}/privacy-protection")
  puts "Privacy protection disabled for #{domain}"
else
  abort("Specify --enable or --disable")
end
