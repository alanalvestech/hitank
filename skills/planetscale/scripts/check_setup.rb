# Check if PlanetScale setup is OK
# Usage: ruby scripts/check_setup.rb

token_id_file = File.expand_path('~/.config/planetscale/token_id')
token_file    = File.expand_path('~/.config/planetscale/token')

unless File.exist?(token_id_file) && File.exist?(token_file)
  puts "SETUP_NEEDED"
  exit 0
end

puts "OK"
