# Check if PostHog setup is OK
# Usage: ruby scripts/check_setup.rb

token_file = File.expand_path('~/.config/posthog/token')
host_file  = File.expand_path('~/.config/posthog/host')

unless File.exist?(token_file)
  puts "SETUP_NEEDED"
  exit 0
end

unless File.exist?(host_file)
  puts "SETUP_NEEDED"
  exit 0
end

puts "OK"
