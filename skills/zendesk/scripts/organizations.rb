# List Zendesk organizations
# Usage: ruby scripts/organizations.rb

require_relative 'auth'

data = zendesk_request(:get, '/organizations')
orgs = data['organizations'] || []

if orgs.empty?
  puts "No organizations found."
  exit 0
end

orgs.each do |o|
  domain = (o['domain_names'] || []).join(', ')
  puts "##{o['id']}\t#{o['name']}\t#{domain}\t#{o['created_at']}"
end
