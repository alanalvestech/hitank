# List all PlanetScale organizations
# Usage: ruby scripts/organizations.rb

require_relative 'auth'

data = ps_request(:get, '/organizations')

orgs = data['data'] || data
orgs = [orgs] unless orgs.is_a?(Array)

orgs.each do |org|
  created = org['created_at'] || '-'
  plan    = org['plan'] || '-'
  puts "#{org['name']}\t#{plan}\t#{created}"
end
