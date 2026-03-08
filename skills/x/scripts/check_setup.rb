# Check if Twitter setup is OK
# Usage: ruby scripts/check_setup.rb

config_dir = File.expand_path('~/.config/x')

files = %w[api_key api_secret access_token access_token_secret]

files.each do |f|
  unless File.exist?(File.join(config_dir, f))
    puts "SETUP_NEEDED"
    exit 0
  end
end

puts "OK"
