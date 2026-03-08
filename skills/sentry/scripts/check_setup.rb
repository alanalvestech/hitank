# Check if Sentry setup is OK
# Usage: ruby scripts/check_setup.rb

token_file = File.expand_path('~/.config/sentry/token')

unless File.exist?(token_file)
  puts "SETUP_NEEDED"
  exit 0
end

puts "OK"
