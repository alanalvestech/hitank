# List Intercom admins/teammates
# Usage: ruby scripts/admins.rb

require_relative 'auth'

data = intercom_request(:get, '/admins')

admins = data['admins'] || []
admins.each do |admin|
  role = admin['type'] || '-'
  puts "#{admin['id']}\t#{admin['name']}\t#{admin['email']}\t#{role}"
end
