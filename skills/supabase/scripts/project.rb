# Get details for a Supabase project
# Usage: ruby scripts/project.rb PROJECT_REF

require_relative 'auth'

ref = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_REF")

data = supabase_request(:get, "/projects/#{ref}")

puts "name:\t#{data['name']}"
puts "id:\t#{data['id']}"
puts "organization_id:\t#{data['organization_id']}"
puts "region:\t#{data['region'] || '-'}"
puts "status:\t#{data['status'] || '-'}"
puts "database_host:\t#{data['database']['host'] rescue '-'}"
puts "created_at:\t#{data['created_at'] || '-'}"
