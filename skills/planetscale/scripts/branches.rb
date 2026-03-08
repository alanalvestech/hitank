# List branches for a PlanetScale database
# Usage: ruby scripts/branches.rb ORG DATABASE

require_relative 'auth'

org = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG DATABASE")
db  = ARGV[1] or abort("Usage: ruby #{__FILE__} ORG DATABASE")

data = ps_request(:get, "/organizations/#{org}/databases/#{db}/branches")

branches = data['data'] || data
branches = [branches] unless branches.is_a?(Array)

branches.each do |b|
  production = b['production'] ? 'production' : 'development'
  created    = b['created_at'] || '-'
  puts "#{b['name']}\t#{production}\t#{created}"
end
