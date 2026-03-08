# List Zendesk users
# Usage: ruby scripts/users.rb

require_relative 'auth'

data = zendesk_request(:get, '/users')
users = data['users'] || []

if users.empty?
  puts "No users found."
  exit 0
end

users.each do |u|
  org = u['organization_id'] || '-'
  puts "##{u['id']}\t#{u['role']}\t#{u['name']}\t#{u['email']}\torg:#{org}"
end
