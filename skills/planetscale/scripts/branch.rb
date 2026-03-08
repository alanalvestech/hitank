# Get details for a PlanetScale branch
# Usage: ruby scripts/branch.rb ORG DATABASE BRANCH

require_relative 'auth'

org    = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG DATABASE BRANCH")
db     = ARGV[1] or abort("Usage: ruby #{__FILE__} ORG DATABASE BRANCH")
branch = ARGV[2] or abort("Usage: ruby #{__FILE__} ORG DATABASE BRANCH")

data = ps_request(:get, "/organizations/#{org}/databases/#{db}/branches/#{branch}")

production  = data['production'] ? 'production' : 'development'
created     = data['created_at'] || '-'
updated     = data['updated_at'] || '-'
parent      = data.dig('parent_branch') || '-'
schema_last = data['schema_last_updated_at'] || '-'

puts "name:\t#{data['name']}"
puts "type:\t#{production}"
puts "parent_branch:\t#{parent}"
puts "created_at:\t#{created}"
puts "updated_at:\t#{updated}"
puts "schema_last_updated_at:\t#{schema_last}"
