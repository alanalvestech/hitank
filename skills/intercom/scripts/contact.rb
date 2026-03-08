# Get Intercom contact details
# Usage: ruby scripts/contact.rb CONTACT_ID

require_relative 'auth'

contact_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CONTACT_ID")

data = intercom_request(:get, "/contacts/#{contact_id}")

name       = data['name'] || '-'
email      = data['email'] || '-'
phone      = data['phone'] || '-'
role       = data['role'] || '-'
created    = data['created_at'] ? Time.at(data['created_at']).strftime('%Y-%m-%d %H:%M') : '-'
last_seen  = data['last_seen_at'] ? Time.at(data['last_seen_at']).strftime('%Y-%m-%d %H:%M') : '-'
signed_up  = data['signed_up_at'] ? Time.at(data['signed_up_at']).strftime('%Y-%m-%d %H:%M') : '-'
city       = data.dig('location', 'city') || '-'
country    = data.dig('location', 'country') || '-'
os         = data['os'] || '-'
browser    = data['browser'] || '-'

puts "id:\t#{data['id']}"
puts "name:\t#{name}"
puts "email:\t#{email}"
puts "phone:\t#{phone}"
puts "role:\t#{role}"
puts "created_at:\t#{created}"
puts "signed_up_at:\t#{signed_up}"
puts "last_seen_at:\t#{last_seen}"
puts "location:\t#{city}, #{country}"
puts "os:\t#{os}"
puts "browser:\t#{browser}"
