# List all Supabase projects
# Usage: ruby scripts/projects.rb

require_relative 'auth'

data = supabase_request(:get, '/projects')

data.each do |project|
  region  = project['region'] || '-'
  status  = project['status'] || '-'
  created = project['created_at'] || '-'
  puts "#{project['name']}\t#{project['id']}\t#{region}\t#{status}\t#{created}"
end
