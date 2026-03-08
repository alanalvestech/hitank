# Check if Cloudinary setup is OK
# Usage: ruby scripts/check_setup.rb

config_dir      = File.expand_path('~/.config/cloudinary')
cloud_name_file = File.join(config_dir, 'cloud_name')
api_key_file    = File.join(config_dir, 'api_key')
api_secret_file = File.join(config_dir, 'api_secret')

[cloud_name_file, api_key_file, api_secret_file].each do |f|
  unless File.exist?(f)
    puts "SETUP_NEEDED"
    exit 0
  end
end

puts "OK"
