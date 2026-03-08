# List persons for a PostHog project
# Usage: ruby scripts/persons.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = posthog_request(:get, "/api/projects/#{project_id}/persons/")

results = data['results'] || data

results.each do |person|
  distinct_id = person['distinct_ids']&.first || '-'
  name        = person.dig('properties', 'name') || person.dig('properties', 'email') || '-'
  created     = person['created_at'] || '-'
  puts "#{person['id']}\t#{distinct_id}\t#{name}\t#{created}"
end
