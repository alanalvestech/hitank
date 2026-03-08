# List saved insights for a PostHog project
# Usage: ruby scripts/insights.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = posthog_request(:get, "/api/projects/#{project_id}/insights/")

results = data['results'] || data

results.each do |insight|
  name       = insight['name'].to_s.empty? ? (insight['derived_name'] || '-') : insight['name']
  short_id   = insight['short_id'] || '-'
  created    = insight['created_at'] || '-'
  last_mod   = insight['last_modified_at'] || '-'
  puts "#{insight['id']}\t#{short_id}\t#{name}\t#{created}\t#{last_mod}"
end
