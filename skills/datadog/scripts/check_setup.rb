# Check if Datadog setup is OK
# Usage: ruby scripts/check_setup.rb

api_key_file = File.expand_path('~/.config/datadog/api_key')
app_key_file = File.expand_path('~/.config/datadog/app_key')

unless File.exist?(api_key_file) && File.exist?(app_key_file)
  puts "SETUP_NEEDED"
  exit 0
end

puts "OK"
