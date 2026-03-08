# Check if Firebase setup is OK
# Usage: ruby scripts/check_setup.rb

service_account_file = File.expand_path('~/.config/firebase/service_account.json')

unless File.exist?(service_account_file)
  puts "SETUP_NEEDED"
  exit 0
end

puts "OK"
