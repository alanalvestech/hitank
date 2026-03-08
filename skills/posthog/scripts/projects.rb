# List all PostHog projects
# Usage: ruby scripts/projects.rb

require_relative 'auth'

data = posthog_request(:get, '/api/projects/')

results = data['results'] || data

results.each do |project|
  name    = project['name'] || '-'
  created = project['created_at'] || '-'
  puts "#{project['id']}\t#{name}\t#{created}"
end
