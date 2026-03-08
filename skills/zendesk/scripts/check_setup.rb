# Check if Zendesk setup is OK
# Usage: ruby scripts/check_setup.rb

config_dir     = File.expand_path('~/.config/zendesk')
token_file     = File.join(config_dir, 'token')
subdomain_file = File.join(config_dir, 'subdomain')
email_file     = File.join(config_dir, 'email')

[token_file, subdomain_file, email_file].each do |f|
  unless File.exist?(f)
    puts "SETUP_NEEDED"
    exit 0
  end
end

puts "OK"
