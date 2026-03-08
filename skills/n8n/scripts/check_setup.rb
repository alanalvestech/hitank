# Check if n8n setup is OK
# Usage: ruby scripts/check_setup.rb

api_key_file = File.expand_path('~/.config/n8n/api_key')
host_file    = File.expand_path('~/.config/n8n/host')

unless File.exist?(api_key_file) && File.exist?(host_file)
  puts "SETUP_NEEDED"
  exit 0
end

puts "OK"
