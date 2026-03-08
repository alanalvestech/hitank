# Save Twilio credentials (Account SID + Auth Token)
# Usage: ruby scripts/save_token.rb ACCOUNT_SID AUTH_TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

account_sid = ARGV[0] or abort("Usage: ruby #{__FILE__} ACCOUNT_SID AUTH_TOKEN")
auth_token  = ARGV[1] or abort("Usage: ruby #{__FILE__} ACCOUNT_SID AUTH_TOKEN")

# Validate by calling the API
uri = URI("https://api.twilio.com/2010-04-01/Accounts/#{account_sid}.json")
req = Net::HTTP::Get.new(uri)
req.basic_auth(account_sid, auth_token)
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid credentials: API returned #{resp.code}"
end

creds_dir  = File.expand_path('~/.config/twilio')
creds_file = File.join(creds_dir, 'credentials')

FileUtils.mkdir_p(creds_dir)
File.write(creds_file, "#{account_sid}:#{auth_token}")
File.chmod(0600, creds_file)

puts "Credentials saved to #{creds_file}"

account = JSON.parse(resp.body)
puts "Verified: account #{account['friendly_name']} (#{account['sid']})"
